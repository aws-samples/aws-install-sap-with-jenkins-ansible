#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Check if the variable is present. If not, send back default value
# ------------------------------------------------------------------
if [ -z "$SUBNET_IDS" ]; then
    echo "Invalid Subnet IDs. It cannot be empty. Go to https://sa-east-1.console.aws.amazon.com/vpc/home?region=sa-east-1#subnets: and select one or more valid subnets"
    exit 100
fi

# If the user sent more than one Subnet, creates the appropriate variable value
if [[ "$SUBNET_IDS" == *","* ]]; then
    SUBNETS="["

    for i in $(echo $SUBNET_IDS | tr "," "\n")
    do
        SUBNETS="$SUBNETS""\"$i\"",
    done

    # Removes trailing ','
    SUBNETS=$(echo $SUBNETS | sed 's/\(.*\),/\1/')
    
    echo "$SUBNETS]"
    exit 0
fi

echo "[$SUBNET_IDS]"
exit 0