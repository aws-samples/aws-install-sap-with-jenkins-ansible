#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

ansiblePASDir="$PWD/ansible-playbooks/aws-sap-pas"

# ------------------------------------------------------------------
# Grab data from Terraform
# ------------------------------------------------------------------
hana_private_ip=$(terraform -chdir="$PWD/$TERRAFORM_FOLDER_NAME" output -json hana_instance_private_ip | jq -r '.[0]')
if [ -z "$hana_private_ip" ]; then
    echo "No Hana instance private IP was found. Please check Terraform step"
    exit 100
fi

ascs_private_ip=$(terraform -chdir="$PWD/$TERRAFORM_FOLDER_NAME" output -json ascs_instance_private_ip | jq -r '.[0]')
if [ -z "$ascs_private_ip" ]; then
    echo "No ASCS instance private IP was found. Please check Terraform step"
    exit 101
fi

pas_public_ip=$(terraform -chdir="$PWD/$TERRAFORM_FOLDER_NAME" output -json app_instance_public_ips | jq -r '.[0]')
if [ -z "$pas_public_ip" ]; then
    echo "No PAS instance public IP was found. Please check Terraform step"
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
hostsFile="$ansiblePASDir/hosts.yml"

sed -i "s/HOST_NAME_TO_APPLY/$pas_public_ip/g" $hostsFile
sed -i "s|PATH_TO_PEM_FILE|$SSH_KEYPAIR_FILE_CHKD|g" $hostsFile

export VAR_FILE_FULL_PATH="$ansiblePASDir/var_file.yaml"
rm $VAR_FILE_FULL_PATH 2> /dev/null
touch $VAR_FILE_FULL_PATH

# ------------------------------------------------------------------
# Add variables to VAR_FILE_FULL_PATH
# ------------------------------------------------------------------
echo "---" >> $VAR_FILE_FULL_PATH
echo "EC2_HOSTNAME: $PAS_INSTANCES_NAME_CHKD" >> $VAR_FILE_FULL_PATH
echo "PRIVATE_DNS_ZONE: $PRIVATE_DNS_ZONE_NAME_CHKD" >> $VAR_FILE_FULL_PATH
echo "MASTER_PASSWORD: $MASTER_PASSWORD_CHKD" >> $VAR_FILE_FULL_PATH
echo "PAS_SID: $SAP_SID_CHKD" >> $VAR_FILE_FULL_PATH
echo "EFS_ID: $efs_id" >> $VAR_FILE_FULL_PATH
echo "PAS_INSTANCE_NUMBER: \"$PAS_INSTANCE_NUMBER_CHKD\"" >> $VAR_FILE_FULL_PATH
echo "DATABASE_SID: $HANA_SID_CHKD" >> $VAR_FILE_FULL_PATH
echo "DATABASE_PRIVATE_IP: $hana_private_ip" >> $VAR_FILE_FULL_PATH
echo "DATABASE_HOSTNAME: $HANA_INSTANCES_NAME_CHKD" >> $VAR_FILE_FULL_PATH
echo "DATABASE_INSTANCE_NUMBER: $HANA_INSTANCE_NUMBER_CHKD" >> $VAR_FILE_FULL_PATH
echo "ASCS_INSTANCE_NUMBER: $ASCS_INSTANCE_NUMBER_CHKD" >> $VAR_FILE_FULL_PATH
echo "ASCS_PRIVATE_IP: $ascs_private_ip" >> $VAR_FILE_FULL_PATH
echo "ASCS_HOSTNAME: $ASCS_INSTANCES_NAME_CHKD" >> $VAR_FILE_FULL_PATH
echo "S3_BUCKET_MEDIA_FILES: $S3_ROOT_FOLDER_INSTALL_FILES_CHKD" >> $VAR_FILE_FULL_PATH
echo "ENABLE_HA: false" >> $VAR_FILE_FULL_PATH
echo "PAS_DB_PRODUCT_ID: $PRODUCT_ID_PAS_DB_CHKD" >> $VAR_FILE_FULL_PATH
echo "PAS_PRODUCT_ID: $PRODUCT_ID_PAS_CHKD" >> $VAR_FILE_FULL_PATH

# ------------------------------------------------------------------
# Run playbook
# ------------------------------------------------------------------
ANSIBLE_HOST_KEY_CHECKING=False

ansible-playbook $ansiblePASDir/site.yml \
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

exit 0