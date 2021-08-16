#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

FOLDER_PATH="./jenkins-pipelines/sap-pipeline-hana-pas-ascs/stages/prepare/check_aws_resources"

# Check S3 folders
$FOLDER_PATH/check_s3_folders.sh
if [ $? -ne 0 ]; then
    exit 100
fi

# Check DNS zone
$FOLDER_PATH/check_dns_zone.sh
if [ $? -ne 0 ]; then
    exit 101
fi

# Check Instance types
$FOLDER_PATH/check_instance_types.sh
if [ $? -ne 0 ]; then
    exit 103
fi

# Check KeyPair
$FOLDER_PATH/check_key_pair.sh
if [ $? -ne 0 ]; then
    exit 104
fi

exit 0