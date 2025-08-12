#!/usr/bin/env bash
set -euo pipefail
source ./env.sh

# Import your existing SSH public key (idempotent)
PUB_KEY="$(cat "$SSH_PUBLIC_KEY_PATH")"
aws ec2 import-key-pair \
  --region "$AWS_REGION" \
  --key-name "$KEY_NAME" \
  --public-key-material "$PUB_KEY" >/dev/null 2>&1 || true

# Create SG allowing SSH from your current IP only
MYIP="$(curl -s https://checkip.amazonaws.com)/32"
SG_ID=$(aws ec2 create-security-group \
  --region "$AWS_REGION" \
  --group-name "${PROJECT_TAG}-sg" \
  --description "SG for ${PROJECT_TAG}" \
  --vpc-id "$VPC_ID" \
  --query 'GroupId' --output text)
# If it already exists, fetch it
if [[ -z "$SG_ID" || "$SG_ID" == "None" ]]; then
  SG_ID=$(aws ec2 describe-security-groups --region "$AWS_REGION" \
    --filters "Name=group-name,Values=${PROJECT_TAG}-sg" "Name=vpc-id,Values=$VPC_ID" \
    --query 'SecurityGroups[0].GroupId' --output text)
fi

aws ec2 authorize-security-group-ingress \
  --region "$AWS_REGION" \
  --group-id "$SG_ID" \
  --ip-permissions "IpProtocol=tcp,FromPort=22,ToPort=22,IpRanges=[{CidrIp=$MYIP,Description=\"SSH from my IP\"}]" >/dev/null 2>&1 || true

echo "SECURITY_GROUP_ID=$SG_ID"
