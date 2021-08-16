#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Check if the variable is present. If not, send back default value
# ------------------------------------------------------------------
if [ -z "$AMI_ID" ]; then
    echo "Invalid AMI ID. Check your AMI Id on AWS Marketplace > RHEL 8.2"
    exit 100
fi

echo "$AMI_ID"
exit 0