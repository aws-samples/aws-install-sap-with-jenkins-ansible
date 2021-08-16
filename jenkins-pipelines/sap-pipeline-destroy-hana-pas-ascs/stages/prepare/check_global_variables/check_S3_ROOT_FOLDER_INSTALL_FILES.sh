#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Check if the variable is present. If not, send back default value
# ------------------------------------------------------------------
if [ -z "$S3_ROOT_FOLDER_INSTALL_FILES" ]; then
    echo "Invalid S3 folder. It cannot be empty. Go to https://s3.console.aws.amazon.com/s3/home?region=sa-east-1# and select a valid bucket"
    exit 100
fi

echo "$S3_ROOT_FOLDER_INSTALL_FILES"
exit 0