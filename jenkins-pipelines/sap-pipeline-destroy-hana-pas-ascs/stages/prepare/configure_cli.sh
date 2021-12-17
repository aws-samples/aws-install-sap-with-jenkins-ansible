#!/bin/bash

# ------------------------------------------------------------------
# Check if the variable is present. If not, send back default value
# ------------------------------------------------------------------
profile_name="jenkins"

aws configure set aws_access_key_id "$AWS_ACCOUNT_CREDENTIALS_USR" --profile "$profile_name"
aws configure set aws_secret_access_key "$AWS_ACCOUNT_CREDENTIALS_PSW" --profile "$profile_name"
aws configure set region "$AWS_REGION" --profile "$profile_name"
aws configure set output json --profile "$profile_name"

# ------------------------------------------------------------------
# Test if connection is working fine
# ------------------------------------------------------------------
aws s3 ls --profile "$profile_name" > /dev/null

if [ $? -gt 0 ]; then
    echo "There was an error establishing connection with the AWS CLI. Check your credentials and the CLI installation"
    exit 100
fi

exit 0