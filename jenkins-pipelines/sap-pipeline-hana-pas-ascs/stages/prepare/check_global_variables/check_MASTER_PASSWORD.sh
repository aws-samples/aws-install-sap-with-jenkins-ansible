#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Check if the variable is present. If not, send back default value
# ------------------------------------------------------------------
if [ -z "$MASTER_PASSWORD" ]; then
    echo "Invalid Master Password. It cannot be empty. Choose a password and try again"
    exit 100
fi

echo "$MASTER_PASSWORD"
exit 0