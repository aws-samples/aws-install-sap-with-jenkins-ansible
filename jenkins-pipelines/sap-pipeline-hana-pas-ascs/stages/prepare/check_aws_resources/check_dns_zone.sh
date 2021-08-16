#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Check if S3 bucket informed by user exists on the AWS account
# ------------------------------------------------------------------
aws route53 list-hosted-zones-by-name --dns-name $PRIVATE_DNS_ZONE_NAME_CHKD --profile "$CLI_PROFILE_CHKD" > /dev/null

if [ $? -ne 0 ]; then
    echo "The Route53 hosted zone $PRIVATE_DNS_ZONE_NAME_CHKD does not exist. Please check again"
    exit 100
fi

exit 0