#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Check if the variable is present. If not, send back default value
# ------------------------------------------------------------------
if [ -z "$AWS_REGION" ]; then
    echo "us-east-1"
    exit 0
fi

echo "$AWS_REGION"
exit 0