#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

ansibleASCSDir="$PWD/ansible-playbooks/aws-sap-ascs-ers"
export ANSIBLE_DIR=$ansibleASCSDir

# ------------------------------------------------------------------
# Grab data from Terraform
# ------------------------------------------------------------------
hana_private_ip=$(terraform -chdir="$PWD/$TERRAFORM_FOLDER_NAME" output -json hana_instance_private_ip | jq -r '.[0]')
if [ -z "$hana_private_ip" ]; then
    echo "No Hana instance private IP was found. Please check Terraform step"
    exit 100
fi

ascs_public_ip=$(terraform -chdir="$PWD/$TERRAFORM_FOLDER_NAME" output -json ascs_instance_public_ips | jq -r '.[0]')
if [ -z "$ascs_public_ip" ]; then
    echo "No ASCS instance public IP was found. Please check Terraform step"
    exit 101
fi
ers_public_ip=$(terraform -chdir="$PWD/$TERRAFORM_FOLDER_NAME" output -json ers_instance_public_ips | jq -r '.[0]')
if [ -z "$ers_public_ip" ]; then
    echo "No ASCS instance public IP was found. Please check Terraform step"
    exit 101
fi

export HOSTS_IPS="[$ascs_public_ip,$ers_public_ip]"

if [[ "$ENABLE_HA_CHKD" == "true" ]]; then
    ascs_private_ip=$(terraform -chdir="$PWD/$TERRAFORM_FOLDER_NAME" output -json ascs_instance_private_ip | jq -r '.[0]')
    ers_private_ip=$(terraform -chdir="$PWD/$TERRAFORM_FOLDER_NAME" output -json ers_instance_private_ip | jq -r '.[0]')
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
# Change host destination on hosts.yml file
# ------------------------------------------------------------------
# Create hosts_runtime.yml file
FOLDER_PATH="./jenkins-pipelines/sap-pipeline-hana-pas-ascs/stages/install_sap"
$FOLDER_PATH/create_hosts_file.sh
if [ $? -ne 0 ]; then
    echo "There was an error creating the hosts file. Please check again"
    exit 104
fi

hostsFile="$ansibleASCSDir/hosts_runtime.yml"

export VAR_FILE_FULL_PATH="$ansibleASCSDir/var_file.yaml"
rm $VAR_FILE_FULL_PATH 2> /dev/null
touch $VAR_FILE_FULL_PATH

# ------------------------------------------------------------------
# Add variables to VAR_FILE_FULL_PATH
# ------------------------------------------------------------------
echo "---" >> $VAR_FILE_FULL_PATH
echo "EC2_HOSTNAME: $ASCS_INSTANCES_NAME_CHKD" >> $VAR_FILE_FULL_PATH
echo "PRIVATE_DNS_ZONE: $PRIVATE_DNS_ZONE_NAME_CHKD" >> $VAR_FILE_FULL_PATH
echo "MASTER_PASSWORD: $MASTER_PASSWORD_CHKD" >> $VAR_FILE_FULL_PATH
echo "EFS_ID: $efs_id" >> $VAR_FILE_FULL_PATH
echo "HANA_PRIVATE_IP: $hana_private_ip" >> $VAR_FILE_FULL_PATH
echo "HANA_HOSTNAME: $HANA_INSTANCES_NAME_CHKD" >> $VAR_FILE_FULL_PATH
echo "S3_BUCKET_MEDIA_FILES: $S3_ROOT_FOLDER_INSTALL_FILES_CHKD" >> $VAR_FILE_FULL_PATH
echo "ENABLE_HA: $ENABLE_HA_CHKD" >> $VAR_FILE_FULL_PATH
echo "PAS_PRIVATE_IP: $pas_private_ip" >> $VAR_FILE_FULL_PATH
echo "PAS_HOSTNAME: $PAS_INSTANCES_NAME_CHKD" >> $VAR_FILE_FULL_PATH

echo "ASCS_PRODUCT_ID: $PRODUCT_ID_ASCS_CHKD" >> $VAR_FILE_FULL_PATH
echo "ASCS_SID: $SAP_SID_CHKD" >> $VAR_FILE_FULL_PATH
echo "ASCS_INSTANCE_NUMBER: \"$ASCS_INSTANCE_NUMBER_CHKD\"" >> $VAR_FILE_FULL_PATH
echo "ASCS_PRIVATE_IP: $ascs_private_ip" >> $VAR_FILE_FULL_PATH
echo "ASCS_HOSTNAME: $ASCS_INSTANCES_NAME_CHKD" >> $VAR_FILE_FULL_PATH

echo "ERS_PRODUCT_ID: $PRODUCT_ID_ERS_CHKD" >> $VAR_FILE_FULL_PATH
echo "ERS_SID: $SAP_SID_CHKD" >> $VAR_FILE_FULL_PATH
echo "ERS_INSTANCE_NUMBER: \"$ERS_INSTANCE_NUMBER_CHKD\"" >> $VAR_FILE_FULL_PATH
echo "ERS_PRIVATE_IP: $ers_private_ip" >> $VAR_FILE_FULL_PATH
echo "ERS_HOSTNAME: $ERS_INSTANCES_NAME_CHKD" >> $VAR_FILE_FULL_PATH

if [[ "$ENABLE_HA_CHKD" == "true" ]]; then
    echo "HA_PRIMARY_PRIVATE_IP: $ascs_private_ip" >> $VAR_FILE_FULL_PATH
    echo "HA_NODE_PRIVATE_IPS: $ers_private_ip," >> $VAR_FILE_FULL_PATH
fi

# ------------------------------------------------------------------
# Run playbook
# ------------------------------------------------------------------
ANSIBLE_HOST_KEY_CHECKING=False

ansible-playbook $ansibleASCSDir/site.yml \
                    --inventory-file "$hostsFile" \
                    --extra-vars "@$VAR_FILE_FULL_PATH"

result_value=$?

if [[ $result_value == 4 ]]; then
    echo "ERROR! It looks like at least one of the hosts were not reachable. Double check your SSH_KEYPAIR_NAME, SSH_KEYPAIR_FILE variables and if your IP is allowed to go through port 22 on the security groups used by your instances"
    exit 100
elif [[ $result_value != 0 ]]; then
    echo "ERROR! There was an error during installation. Check the logs and try again"
    exit 101
fi

rm -rf $ansibleASCSDir
exit 0