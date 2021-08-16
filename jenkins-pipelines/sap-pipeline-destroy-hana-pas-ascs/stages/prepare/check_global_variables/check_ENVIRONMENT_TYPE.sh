#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Check if the variable is present. If not, send back default value
# ------------------------------------------------------------------
if [ -z "$ENVIRONMENT_TYPE" ]; then
    echo "dev"
    exit 0
fi

echo "$ENVIRONMENT_TYPE"
exit 0