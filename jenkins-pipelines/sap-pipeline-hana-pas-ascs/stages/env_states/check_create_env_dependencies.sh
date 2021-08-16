#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

FOLDER_PATH="./jenkins-pipelines/sap-pipeline-hana-pas-ascs/stages/env_states"

# Check S3 bucket for storing TF states
$FOLDER_PATH/check_create_env_bucket.sh
if [ $? -ne 0 ]; then
    exit 100
fi

# Check DynamoDB for locking terraform states
$FOLDER_PATH/check_create_table_tf_lock.sh
if [ $? -ne 0 ]; then
    exit 100
fi