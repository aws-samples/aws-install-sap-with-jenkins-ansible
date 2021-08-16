#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Check if the variable is present. If not, throw error
# ------------------------------------------------------------------
if [ -z "$SSH_KEYPAIR_FILE" ]; then
    echo "Invalid file for KeyPair. You must upload a file already existing on https://console.aws.amazon.com/ec2/v2/home#KeyPairs:"
    exit 100
fi

echo "$SSH_KEYPAIR_FILE"
exit 0