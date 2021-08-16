#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Check if the variable is present. If not, throw error
# ------------------------------------------------------------------
if [ -z "$KMS_KEY_ARN" ]; then
    echo "Invalid KMS Key ARN. It cannot be empty. Go to https://console.aws.amazon.com/kms/home?region=us-east-1#/kms/keys and use a valid Key ARN"
    exit 100
fi

echo "$KMS_KEY_ARN"

exit 0