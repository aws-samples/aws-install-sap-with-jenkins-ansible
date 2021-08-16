#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

terraform -chdir="$PWD/$TERRAFORM_FOLDER_NAME" \
                init \
                -backend-config "bucket=$BUCKET_NAME_CHKD" \
                -backend-config "key=environment.tfstate" \
                -backend-config "region=$AWS_REGION_CHKD" \
                -backend-config "access_key=$AWS_ACCOUNT_CREDENTIALS_USR" \
                -backend-config "secret_key=$AWS_ACCOUNT_CREDENTIALS_PSW" \
                -backend-config "dynamodb_table=$DYNAMO_TABLE_TF_LOCK" \
                > /dev/null

if [ $? -gt 0 ]; then
    echo "Error with Terraform Init. Please check again"
    exit 100
fi

terraform -chdir="$PWD/$TERRAFORM_FOLDER_NAME" \
                destroy \
                -auto-approve \
                -var "aws_access_key=$AWS_ACCOUNT_CREDENTIALS_USR" \
                -var "aws_secret_key=$AWS_ACCOUNT_CREDENTIALS_PSW" \
                -var "aws_region=$AWS_REGION_CHKD" \
                -var "ssh_key=$SSH_KEYPAIR_NAME_CHKD" \
                -var "ascs_instance_type=$ASCS_INSTANCE_TYPE_CHKD" \
                -var "as_instance_type=$PAS_INSTANCE_TYPE_CHKD" \
                -var "hana_instance_type=$HANA_INSTANCE_TYPE_CHKD" \
                -var "vpc_id=$VPC_ID_CHKD" \
                -var "subnet_ids=$SUBNET_IDS_CHKD" \
                -var "dns_zone_name=$PRIVATE_DNS_ZONE_NAME_CHKD" \
                -var "sid=$SAP_SID_CHKD" \
                -var "application_code=$APPLICATION_CODE_CHKD" \
                -var "application_name=$APPLICATION_NAME_CHKD" \
                -var "environment_type=$ENVIRONMENT_TYPE_CHKD" \
                -var "customer_default_sg_id=$SECURITY_GROUP_ID_CHKD" \
                -var "enable_ha=$ENABLE_HA_CHKD" \
                -var "ami_id=$AMI_ID_CHKD" \
                -var "kms_key_arn=$KMS_KEY_ARN" \
                -lock-timeout=10m

if [ $? -gt 0 ]; then
    echo "Error with Terraform Destroy. Please check again"
    exit 101
fi