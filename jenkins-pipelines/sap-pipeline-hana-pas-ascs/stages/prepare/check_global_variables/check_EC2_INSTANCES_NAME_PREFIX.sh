#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Check if the variable is present. If not, send back default value
# ------------------------------------------------------------------
if [ -z "$EC2_INSTANCES_NAME_PREFIX" ]; then
    echo "demo"
    exit 0
fi

echo "$EC2_INSTANCES_NAME_PREFIX"
exit 0