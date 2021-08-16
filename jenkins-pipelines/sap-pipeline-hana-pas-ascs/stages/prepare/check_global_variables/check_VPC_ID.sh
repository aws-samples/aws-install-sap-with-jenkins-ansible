#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Check if the variable is present. If not, send back default value
# ------------------------------------------------------------------
if [ -z "$VPC_ID" ]; then
    echo "Invalid VPC_ID. It cannot be empty. Go to https://sa-east-1.console.aws.amazon.com/vpc/home?region=sa-east-1#vpcs: and select one valid VPC"
    exit 100
fi

echo "$VPC_ID"
exit 0