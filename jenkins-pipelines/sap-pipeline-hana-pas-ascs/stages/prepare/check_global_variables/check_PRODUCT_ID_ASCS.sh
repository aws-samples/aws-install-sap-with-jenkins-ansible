#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Check if the variable is present. If not, send back default value
# ------------------------------------------------------------------
if [ -z "$PRODUCT_ID_ASCS" ]; then
    echo "NW_ABAP_ASCS:S4HANA1909.CORE.HDB.ABAP"
    exit 0
fi

echo "$PRODUCT_ID_ASCS"
exit 0