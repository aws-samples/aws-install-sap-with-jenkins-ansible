# AWS-SAP-NETWEAVER

```
Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
SPDX-License-Identifier: MIT-0
```

This repo contains the ansible code for installing SAP Netweaver on AWS instances

## How to run: 

### 1 - Requirements

1. Follow <a href=https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#selecting-an-ansible-artifact-and-version-to-install>this link</a> to install Ansible on your local computer

### 2 - Setup - Download dependencies:
1. Go to roles/requirements.yml and fill in with your Gitlab USER/TOKEN on the specified places
2. Run the command <code>ansible-galaxy install -f -r requirements.yml</code>

### 3 - Running the playbook:
1. Go to hosts.yml and fill in with your instance's IP (from previous step) and SSH key path
2. Use the example on how_to_run.sh to check if you want to change any variable, and run the playbook

## Customizable variables:

The following variables can be customized for your Netweaver installation. Change them on your local how_to_run.sh

Variable | Description | Default Value
--- | --- | ---
EC2_HOSTNAME | The hostname to be applied on the instance | demo-ascs
PRIVATE_DNS_ZONE | Private DNS Zone to be applied on the instance | sapgspteam.net
MASTER_PASSWORD | The master password for Hana installation | P@ssw0rd
ASCS_SID | The SID for the ASCS Installation | AD0
EFS_ID | The AWS EFS ID to be attached to the instance | fs-xxxxxxxx
ASCS_INSTANCE_NUMBER | The SAP instance number for this ASCS instance | 00
HANA_PRIVATE_IP | Hana's database private IP | 172.0.0.0
HANA_HOSTNAME | Hana's database hostname | demo-hana
PAS_PRIVATE_IP | PAS private IP to be added to /etc/hosts | 172.0.0.0
PAS_HOSTNAME | PAS hostname to be added to /etc/hosts | demo-pas
S3_BUCKET_MEDIA_FILES | S3 bucket to download ASCS installer from | s3://sapgspdemo-sap-binaries-lw/S4H1909/

IMPORTANT! This playbook reboots the destined instance, and therefore cannot be run on localhost

## FAQ

<b>Q:</b> How long does the "Download ASCS from S3 bucket" step take?
<br><b>A:</b> Using "aws sync" for downloading the folder form an S3 bucket using only Amazon network this should take up to 15 minutes to download the whole 63Gb

<b>Q:</b> How long does the "Install ASCS" step take?
<br><b>A:</b>For a r5.4xlarge instance size, 30 minutes, typically
