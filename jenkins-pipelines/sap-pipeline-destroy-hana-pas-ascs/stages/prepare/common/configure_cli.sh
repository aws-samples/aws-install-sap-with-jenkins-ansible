#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Check if the variable is present. If not, send back default value
# ------------------------------------------------------------------
aws configure set aws_access_key_id "$AWS_ACCOUNT_CREDENTIALS_USR" --profile "$CLI_PROFILE_CHKD"
aws configure set aws_secret_access_key "$AWS_ACCOUNT_CREDENTIALS_PSW" --profile "$CLI_PROFILE_CHKD"
aws configure set region "$AWS_REGION" --profile "$CLI_PROFILE_CHKD"
aws configure set output json --profile "$CLI_PROFILE_CHKD"

# ------------------------------------------------------------------
# Test if connection is working fine
# ------------------------------------------------------------------
aws s3 ls --profile "$CLI_PROFILE_CHKD" > /dev/null

if [ $? -gt 0 ]; then
    echo "There was an error establishing connection with the AWS CLI. Check your credentials and the CLI installation"
    exit 100
fi

exit 0