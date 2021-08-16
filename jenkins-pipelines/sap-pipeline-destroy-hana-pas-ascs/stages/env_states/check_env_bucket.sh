#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Check if the variable is present. If not, send back default value
# ------------------------------------------------------------------
aws s3 ls $BUCKET_NAME_CHKD --profile "$CLI_PROFILE_CHKD" > /dev/null

if [ $? -gt 0 ]; then
    echo "The bucket $BUCKET_NAME_CHKD doesn't exist. Please check if the AWS ID you're using is the same of the installation you're trying to destroy"
fi

exit 0