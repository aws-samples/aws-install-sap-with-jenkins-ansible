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

# ------------------------------------------------------------------
# Download ASCS dependencies
# ------------------------------------------------------------------
ansible-galaxy install -f -r "ansible-playbooks/aws-sap-ascs-ers/roles/requirements.yml"

if [ $? -ne 0 ]; then
    echo "There was an error while downloading ASCS playbook dependencies. Please try again"
    exit 104
fi
# ------------------------------------------------------------------
# Download Hana dependencies
# ------------------------------------------------------------------
ansible-galaxy install -f -r "ansible-playbooks/aws-sap-hana/roles/requirements.yml"

if [ $? -ne 0 ]; then
    echo "There was an error while downloading Hana playbook dependencies. Please try again"
    exit 103
fi
# ------------------------------------------------------------------
# Download PAS dependencies
# ------------------------------------------------------------------
ansible-galaxy install -f -r "ansible-playbooks/aws-sap-pas/roles/requirements.yml"

if [ $? -ne 0 ]; then
    echo "There was an error while downloading PAS playbook dependencies. Please try again"
    exit 104
fi