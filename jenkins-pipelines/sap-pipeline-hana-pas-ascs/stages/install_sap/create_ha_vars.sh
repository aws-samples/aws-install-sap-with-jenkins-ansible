#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Grab data from Terraform
# ------------------------------------------------------------------
if [ -z "$PRIVATE_IPS_LIST" ]; then
    echo "No private IP list was found. Please check again"
    exit 100
fi

if [ -z "$VAR_FILE_FULL_PATH" ]; then
    echo "No Var File full path was found. Please check again"
    exit 100
fi

private_ip_values=$(echo $PRIVATE_IPS_LIST | sed "s/\[/\ /g" | sed "s/\]/\ /g" | sed "s/\,/\ /g")
eval "private_ips_array=($private_ip_values)"

# ------------------------------------------------------------------
# Create variables
# ------------------------------------------------------------------
for ((idx=1; idx<${#private_ips_array[@]}; idx++)); do
    node_ips=$node_ips"${private_ips_array[idx]}",
done

echo "HA_PRIMARY_PRIVATE_IP: ${private_ips_array[0]}" >> $VAR_FILE_FULL_PATH
echo "HA_NODE_PRIVATE_IPS: $node_ips" >> $VAR_FILE_FULL_PATH

exit 0