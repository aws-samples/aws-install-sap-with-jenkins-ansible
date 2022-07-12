#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

post_install_playbook_dir="$PWD/ansible-playbooks/aws-sap-ascs-hana-pas-post-install"
export ANSIBLE_DIR=$post_install_playbook_dir

# ------------------------------------------------------------------
# Grab data from Terraform
# ------------------------------------------------------------------
hana_public_ips=$(terraform -chdir="$PWD/$TERRAFORM_FOLDER_NAME" output -json hana_instance_public_ips)
if [ -z "$hana_public_ips" ]; then
    echo "No Hana instance IPs were found. Please check Terraform step"
    exit 100
fi
export HANA_HOSTS_IPS=$hana_public_ips

export ASCS_PUBLIC_IP=$(terraform -chdir="$PWD/$TERRAFORM_FOLDER_NAME" output -json ascs_instance_public_ips | jq -r '.[0]')
if [ -z "$ASCS_PUBLIC_IP" ]; then
    echo "No ASCS instance public IP was found. Please check Terraform step"
    exit 101
fi
export ERS_PUBLIC_IP=$(terraform -chdir="$PWD/$TERRAFORM_FOLDER_NAME" output -json ers_instance_public_ips | jq -r '.[0]')
if [ -z "$ERS_PUBLIC_IP" ]; then
    echo "No ASCS instance public IP was found. Please check Terraform step"
    exit 101
fi

export PAS_PUBLIC_IP=$(terraform -chdir="$PWD/$TERRAFORM_FOLDER_NAME" output -json app_instance_public_ips | jq -r '.[0]')
if [ -z "$PAS_PUBLIC_IP" ]; then
    echo "No PAS instance public IP was found. Please check Terraform step"
    exit 102
fi

# ------------------------------------------------------------------
# Create hosts file
# ------------------------------------------------------------------
# Create hosts_runtime.yml file
FOLDER_PATH="./jenkins-pipelines/sap-pipeline-hana-pas-ascs/stages/install_sap"
$FOLDER_PATH/update_hosts_file.sh
if [ $? -ne 0 ]; then
    echo "There was an error creating the hosts file. Please check again"
    exit 104
fi

hostsFile="$post_install_playbook_dir/hosts_runtime.yaml"

export VAR_FILE_FULL_PATH="$post_install_playbook_dir/var_file.yaml"
rm $VAR_FILE_FULL_PATH 2> /dev/null
touch $VAR_FILE_FULL_PATH

# ------------------------------------------------------------------
# Add variables to VAR_FILE_FULL_PATH
# ------------------------------------------------------------------
echo "---" >> $VAR_FILE_FULL_PATH
echo "INPUT_DNS_ZONE_NAME: $PRIVATE_DNS_ZONE_NAME_CHKD" >> $VAR_FILE_FULL_PATH

# ------------------------------------------------------------------
# Run playbook
# ------------------------------------------------------------------
ANSIBLE_HOST_KEY_CHECKING=False
ANSIBLE_BECOME_EXE="sudo su -"

ansible-playbook $post_install_playbook_dir/merge_hosts.yaml \
                    --inventory-file "$hostsFile" \
                    --extra-vars "@$VAR_FILE_FULL_PATH"

result_value=$?

if [[ $result_value == 4 ]]; then
    echo "ERROR! It looks like at least one of the hosts were not reachable. Double check your SSH_KEYPAIR_NAME, SSH_KEYPAIR_FILE variables and if your IP is allowed to go through port 22 on the security groups used by your instances"
    exit 110
elif [[ $result_value != 0 ]]; then
    echo "ERROR! There was an error during installation. Check the logs and try again"
    exit 111
fi

exit 0