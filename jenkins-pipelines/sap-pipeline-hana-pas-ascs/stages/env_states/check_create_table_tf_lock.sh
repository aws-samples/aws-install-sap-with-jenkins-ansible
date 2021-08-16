#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Check if the variable is present. If not, send back default value
# ------------------------------------------------------------------
table_exists=$(aws dynamodb list-tables --profile "$CLI_PROFILE_CHKD" | grep -c "$DYNAMO_TABLE_NAME_CHKD")

if [ "$table_exists" -eq 0 ]; then
    aws dynamodb create-table \
        --table-name $DYNAMO_TABLE_NAME_CHKD \
        --attribute-definitions \
            AttributeName=LockID,AttributeType=S \
        --key-schema \
            AttributeName=LockID,KeyType=HASH \
        --provisioned-throughput \
            ReadCapacityUnits=1,WriteCapacityUnits=1 \
        --profile "$CLI_PROFILE_CHKD"

    if [ $? -ne 0 ]; then
        echo "There was an error creating your DynamoDB table ("$DYNAMO_TABLE_NAME_CHKD") for storing Terraform state locks. Please check your access privileges and try again"
        exit 100
    fi

    echo "The DynamoDB table $DYNAMO_TABLE_NAME_CHKD didn't exist and was successfully created"
fi

exit 0