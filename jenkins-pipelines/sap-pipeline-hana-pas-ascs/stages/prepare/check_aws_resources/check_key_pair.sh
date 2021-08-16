#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Check if the KeyPair is valid
# ------------------------------------------------------------------
kp_found=$(aws ec2 describe-key-pairs --profile "$CLI_PROFILE_CHKD" | grep -c "$SSH_KEYPAIR_NAME_CHKD")

if [ "$kp_found" -eq 0 ]; then
    echo "The KeyPair informed \"$SSH_KEYPAIR_NAME_CHKD\" is invalid"
    exit 100
fi

exit 0