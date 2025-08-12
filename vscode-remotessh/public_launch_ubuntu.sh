#!/usr/bin/env bash
set -euo pipefail
source ./env.sh

# --- Ensure key pair exists ---
if ! aws ec2 describe-key-pairs --region "$AWS_REGION" --key-names "$KEY_NAME" >/dev/null 2>&1; then
  echo "Importing key pair $KEY_NAME"
  aws ec2 import-key-pair --region "$AWS_REGION" --key-name "$KEY_NAME" \
    --public-key-material "$(cat "$SSH_PUBLIC_KEY_PATH")" >/dev/null
fi

# --- Ensure SG exists with SSH from your IP ---
SG_NAME="${PROJECT_TAG}-sg"
SG_ID=$(aws ec2 describe-security-groups --region "$AWS_REGION" \
  --filters "Name=group-name,Values=${SG_NAME}" "Name=vpc-id,Values=$VPC_ID" \
  --query 'SecurityGroups[0].GroupId' --output text 2>/dev/null || true)

if [[ -z "$SG_ID" || "$SG_ID" == "None" ]]; then
  echo "Creating security group $SG_NAME"
  SG_ID=$(aws ec2 create-security-group --region "$AWS_REGION" \
    --group-name "$SG_NAME" --description "SG for ${PROJECT_TAG}" --vpc-id "$VPC_ID" \
    --query 'GroupId' --output text)
fi

MYIP="$(curl -s https://checkip.amazonaws.com)/32"
# add/ensure SSH rule
aws ec2 authorize-security-group-ingress --region "$AWS_REGION" --group-id "$SG_ID" \
  --ip-permissions "IpProtocol=tcp,FromPort=22,ToPort=22,IpRanges=[{CidrIp=$MYIP,Description=\"SSH from my IP\"}]" >/dev/null 2>&1 || true

# --- Resolve Ubuntu 24.04 AMI (x86_64) ---
try_ssm() { aws ssm get-parameter --region "$AWS_REGION" --name "$1" --query 'Parameter.Value' --output text 2>/dev/null || true; }
AMI_ID="$(try_ssm '/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id')"
[[ -z "$AMI_ID" || "$AMI_ID" == "None" ]] && AMI_ID="$(try_ssm '/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp2/ami-id')"
if [[ -z "$AMI_ID" || "$AMI_ID" == "None" ]]; then
  AMI_ID="$(aws ec2 describe-images --region "$AWS_REGION" --owners 099720109477 \
    --filters 'Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-noble-24.04-amd64-server-*' \
              'Name=architecture,Values=x86_64' 'Name=virtualization-type,Values=hvm' 'Name=root-device-type,Values=ebs' \
    --query 'Images | sort_by(@,&CreationDate)[-1].ImageId' --output text)"
fi
[[ -z "$AMI_ID" || "$AMI_ID" == "None" ]] && { echo "AMI lookup failed"; exit 1; }
echo "Using AMI_ID=$AMI_ID"

# --- Cloud-init for user + ssh key ---
read -r -d '' USER_DATA <<'CLOUD'
#cloud-config
package_update: true
runcmd:
  - adduser --disabled-password --gecos "" DEV_USERNAME
  - usermod -aG sudo DEV_USERNAME
  - mkdir -p /home/DEV_USERNAME/.ssh && chmod 700 /home/DEV_USERNAME/.ssh
  - echo "SSH_PUBKEY" >> /home/DEV_USERNAME/.ssh/authorized_keys
  - chown -R DEV_USERNAME:DEV_USERNAME /home/DEV_USERNAME/.ssh
  - sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config
  - systemctl restart ssh
CLOUD
USER_DATA="${USER_DATA/DEV_USERNAME/$DEV_USERNAME}"
USER_DATA="${USER_DATA/SSH_PUBKEY/$(cat "$SSH_PUBLIC_KEY_PATH")}"

# --- Launch ---
INSTANCE_ID=$(aws ec2 run-instances --region "$AWS_REGION" \
  --image-id "$AMI_ID" --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_NAME" --subnet-id "$SUBNET_PUBLIC" --security-group-ids "$SG_ID" \
  --associate-public-ip-address \
  --block-device-mappings "DeviceName=/dev/sda1,Ebs={VolumeSize=$VOLUME_GB,VolumeType=gp3,DeleteOnTermination=true}" \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${PROJECT_TAG}},{Key=Project,Value=${PROJECT_TAG}}]" \
  --user-data "$USER_DATA" --query 'Instances[0].InstanceId' --output text)

echo "INSTANCE_ID=$INSTANCE_ID"
aws ec2 wait instance-status-ok --region "$AWS_REGION" --instance-ids "$INSTANCE_ID"

PUBLIC_IP=$(aws ec2 describe-instances --region "$AWS_REGION" --instance-ids "$INSTANCE_ID" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)

echo "PUBLIC_IP=$PUBLIC_IP"
echo "ssh -i ~/.ssh/id_ed25519 ${DEV_USERNAME}@${PUBLIC_IP}"
