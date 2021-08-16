#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Check if S3 bucket informed by user exists on the AWS account
# ------------------------------------------------------------------
aws s3 ls "$S3_ROOT_FOLDER_INSTALL_FILES_CHKD" --profile "$CLI_PROFILE_CHKD" > /dev/null

if [ $? -ne 0 ]; then
    echo "The S3 bucket $S3_ROOT_FOLDER_INSTALL_FILES_CHKD does not exist. Please check again"
    exit 100
fi

exit 0