# ======== COMMON VARS ========
export AWS_REGION="ap-southeast-1"

# Networking
export VPC_ID="vpc-0f4880c59df53fb15"
export SUBNET_PUBLIC="subnet-0e1f738fc893f4b4c"
export SUBNET_PRIVATE="subnet-0e1996aee424f8559"

# Identity
export KEY_NAME="ansible-dev-key"
export SSH_PUBLIC_KEY_PATH="$HOME/.ssh/id_rsa.pub"   # existing public key

# Instance
export INSTANCE_TYPE="t3.small"
export VOLUME_GB="60"
export DEV_USERNAME="dev"
export PROJECT_TAG="ansible-dev"