#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Check if S3 bucket informed by user exists on the AWS account
# ------------------------------------------------------------------
bucketName=$(aws s3api list-buckets --profile "$CLI_PROFILE_CHKD" | jq '.Buckets[].Name | select(test("sap-install-bucket*"))' -r)

if [ -z $bucketName ]; then
    echo "There's no S3 bucket matching the \"sap-install-bucket*\" pattern. It will be created next time the Spin up Env pipeline is run"
    exit 100
fi

echo $bucketName
exit 0