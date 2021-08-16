#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Check if the variable is present. If not, throw error
# ------------------------------------------------------------------
if [ -z "$SSH_KEYPAIR_NAME" ]; then
    echo "Invalid AWS KeyPair name. It cannot be empty. Go to https://console.aws.amazon.com/ec2/v2/home#KeyPairs: and grab a valid KeyPair name"
    exit 100
fi

echo "$SSH_KEYPAIR_NAME"

exit 0