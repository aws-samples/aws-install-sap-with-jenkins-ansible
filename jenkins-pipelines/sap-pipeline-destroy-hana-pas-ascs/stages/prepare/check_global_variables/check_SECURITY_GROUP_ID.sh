#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Check if the variable is present. If not, send back default value
# ------------------------------------------------------------------
if [ -z "$SECURITY_GROUP_ID" ]; then
    echo "Invalid Security Group ID. It cannot be empty. Go to https://sa-east-1.console.aws.amazon.com/ec2/v2/home?region=sa-east-1#SecurityGroups: and select a valid group"
    exit 100
fi

echo "$SECURITY_GROUP_ID"
exit 0