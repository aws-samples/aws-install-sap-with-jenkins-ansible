#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Check if the variable is present. If not, send back default value
# ------------------------------------------------------------------
aws s3 ls $BUCKET_NAME_CHKD --profile "$CLI_PROFILE_CHKD" > /dev/null

if [ $? -ne 0 ]; then
    aws s3api create-bucket --bucket $BUCKET_NAME_CHKD --profile "$CLI_PROFILE_CHKD"

    if [ $? -ne 0 ]; then
        echo "There was an error creating your default bucket: $BUCKET_NAME_CHKD"
        exit 100
    fi

    echo "The bucket $BUCKET_NAME_CHKD didn't exist and was successfully created"
fi

exit 0