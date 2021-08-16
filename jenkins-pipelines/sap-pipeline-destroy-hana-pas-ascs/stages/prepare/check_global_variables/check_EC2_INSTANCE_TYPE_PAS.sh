#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Check if the variable is present. If not, send back default value
# ------------------------------------------------------------------
if [ -z "$PAS_INSTANCE_TYPE" ]; then
    echo "m5.xlarge"
    exit 0
fi

echo "$PAS_INSTANCE_TYPE"
exit 0