#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

roleDestDir="/etc/ansible/roles"
hanaDir="ansible-playbooks/aws-sap-hana/roles/"
ascsDir="ansible-playbooks/aws-sap-ascs-ers/roles/"
pasDir="ansible-playbooks/aws-sap-pas/roles/"

cp -r $PWD/ansible-playbooks/shared-roles/* $hanaDir
cp -r $PWD/ansible-playbooks/shared-roles/* $ascsDir
cp -r $PWD/ansible-playbooks/shared-roles/* $pasDir