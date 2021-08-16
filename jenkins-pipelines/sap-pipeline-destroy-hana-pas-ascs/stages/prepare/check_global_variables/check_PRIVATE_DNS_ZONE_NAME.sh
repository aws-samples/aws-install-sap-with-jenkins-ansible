#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Check if the variable is present. If not, send back default value
# ------------------------------------------------------------------
if [ -z "$PRIVATE_DNS_ZONE_NAME" ]; then
    echo "Invalid private DNS Zone name. It cannot be empty. Go to https://console.aws.amazon.com/route53/v2/home#Dashboard and copy a valid Route53"
    exit 100
fi

echo "$PRIVATE_DNS_ZONE_NAME"
exit 0