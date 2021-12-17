#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

ansibleHanaDir="$PWD/ansible-playbooks/aws-sap-hana"
export ANSIBLE_DIR=$ansibleHanaDir

# ------------------------------------------------------------------
# Grab data from Terraform
# ------------------------------------------------------------------
hana_public_ips=$(terraform -chdir="$PWD/$TERRAFORM_FOLDER_NAME" output -json hana_instance_public_ips)
if [ -z "$hana_public_ips" ]; then
    echo "No Hana instance IPs were found. Please check Terraform step"
    exit 100
fi
export HOSTS_IPS=$hana_public_ips

if [[ "$ENABLE_HA_CHKD" == "true" ]]; then
    hana_private_ips=$(terraform -chdir="$PWD/$TERRAFORM_FOLDER_NAME" output -json hana_instance_private_ip)
    export PRIVATE_IPS_LIST=$hana_private_ips

    hana_overlay_ip=$(terraform -chdir="$PWD/$TERRAFORM_FOLDER_NAME" output -json hana_instance_overlay_ip)
    if [ -z "$hana_overlay_ip" ]; then
        echo "No overlay IP was found for Hana. Please check Terraform step"
        exit 104
    fi

    hana_overlay_route_table_id=$(terraform -chdir="$PWD/$TERRAFORM_FOLDER_NAME" output -json hana_overlay_ip_route_table_id)
    if [ -z "$hana_overlay_route_table_id" ]; then
        echo "No ID for the overlay IP route table was found for Hana. Please check Terraform step"
        exit 105
    fi
fi

ascs_private_ip=$(terraform -chdir="$PWD/$TERRAFORM_FOLDER_NAME" output -json ascs_instance_private_ip | jq -r '.[0]')
if [ -z "$ascs_private_ip" ]; then
    echo "No ASCS instance private IP was found. Please check Terraform step"
    exit 101
fi

pas_private_ip=$(terraform -chdir="$PWD/$TERRAFORM_FOLDER_NAME" output -json app_instance_private_ip | jq -r '.[0]')
if [ -z "$pas_private_ip" ]; then
    echo "No PAS instance private IP was found. Please check Terraform step"
    exit 102
fi

efs_id=$(terraform -chdir="$PWD/$TERRAFORM_FOLDER_NAME" output -raw app_instance_efs_ids)
if [ -z "$efs_id" ]; then
    echo "No EFS ID was found. Please check Terraform step"
    exit 103
fi

# ------------------------------------------------------------------
# Create hosts file
# ------------------------------------------------------------------
# Create hosts_runtime.yml file
FOLDER_PATH="./jenkins-pipelines/sap-pipeline-hana-pas-ascs/stages/install_sap"
$FOLDER_PATH/create_hosts_file.sh
if [ $? -ne 0 ]; then
    echo "There was an error creating the hosts file. Please check again"
    exit 104
fi

hostsFile="$ansibleHanaDir/hosts_runtime.yml"

export VAR_FILE_FULL_PATH="$ansibleHanaDir/var_file.yaml"
rm $VAR_FILE_FULL_PATH 2> /dev/null
touch $VAR_FILE_FULL_PATH

# ------------------------------------------------------------------
# Add variables to VAR_FILE_FULL_PATH
# ------------------------------------------------------------------
echo "---" >> $VAR_FILE_FULL_PATH
echo "EC2_HOSTNAME: $HANA_INSTANCES_NAME_CHKD" >> $VAR_FILE_FULL_PATH
echo "PRIVATE_DNS_ZONE: $PRIVATE_DNS_ZONE_NAME_CHKD" >> $VAR_FILE_FULL_PATH
echo "MASTER_PASSWORD: $MASTER_PASSWORD_CHKD" >> $VAR_FILE_FULL_PATH
echo "HANA_SID: $HANA_SID_CHKD" >> $VAR_FILE_FULL_PATH
echo "HANA_INSTANCE_NUMBER: \"$HANA_INSTANCE_NUMBER_CHKD\"" >> $VAR_FILE_FULL_PATH
echo "EFS_ID: $efs_id" >> $VAR_FILE_FULL_PATH
echo "S3_BUCKET_MEDIA_FILES: $S3_ROOT_FOLDER_INSTALL_FILES_CHKD" >> $VAR_FILE_FULL_PATH
echo "ASCS_PRIVATE_IP: $ascs_private_ip" >> $VAR_FILE_FULL_PATH
echo "ASCS_HOSTNAME: $ASCS_INSTANCES_NAME_CHKD" >> $VAR_FILE_FULL_PATH
echo "PAS_PRIVATE_IP: $pas_private_ip" >> $VAR_FILE_FULL_PATH
echo "PAS_HOSTNAME: $PAS_INSTANCES_NAME_CHKD" >> $VAR_FILE_FULL_PATH
echo "PAS_SID: $SAP_SID_CHKD" >> $VAR_FILE_FULL_PATH
echo "ENABLE_HA: $ENABLE_HA_CHKD" >> $VAR_FILE_FULL_PATH
echo "AWS_CLI_PROFILE: $CLI_PROFILE_CHKD" >> $VAR_FILE_FULL_PATH
echo "BUCKET_TO_BACKUP: $BUCKET_NAME_CHKD" >> $VAR_FILE_FULL_PATH
echo "AWS_REGION: $AWS_REGION_CHKD" >> $VAR_FILE_FULL_PATH
echo "OVERLAY_IP: $hana_overlay_ip" >> $VAR_FILE_FULL_PATH
echo "OVERLAY_IP_ROUTE_TABLE_ID: $hana_overlay_route_table_id" >> $VAR_FILE_FULL_PATH

# ------------------------------------------------------------------
# Parse private IPs for HA
# ------------------------------------------------------------------
if [[ "$ENABLE_HA_CHKD" == "true" ]]; then
    $FOLDER_PATH/create_ha_vars.sh
    if [ $? -ne 0 ]; then
        echo "There was an error creating the hosts file. Please check again"
        exit 104
    fi
fi

# ------------------------------------------------------------------
# Run playbook
# ------------------------------------------------------------------
ANSIBLE_HOST_KEY_CHECKING=False
ANSIBLE_BECOME_EXE="sudo su -"

ansible-playbook $ansibleHanaDir/site.yml \
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