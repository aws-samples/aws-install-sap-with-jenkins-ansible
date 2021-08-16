#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Check if the variable is present. If not, send back default value
# ------------------------------------------------------------------
if [ -z "$MASTER_PASSWORD" ]; then
    echo "P@ssw0rd"
    exit 0
fi

echo "$MASTER_PASSWORD"
exit 0