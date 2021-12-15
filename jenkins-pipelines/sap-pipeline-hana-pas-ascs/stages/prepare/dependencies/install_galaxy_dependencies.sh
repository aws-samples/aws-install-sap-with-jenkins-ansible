#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Install Ansible Galaxy dependencies
# ------------------------------------------------------------------
ansible-galaxy collection install amazon.aws

if [ $? -ne 0 ]; then
    echo "There was an error while installing AWS dependencies for Ansible. Please try again"
    exit 101
fi