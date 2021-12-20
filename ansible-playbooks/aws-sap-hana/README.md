# AWS-SAP-NETWEAVER

```
Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
SPDX-License-Identifier: MIT-0
```

This repo contains the ansible code for installing SAP Hana on AWS instances

## How to run: 

### 1 - Requirements

1. Follow <a href=https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#selecting-an-ansible-artifact-and-version-to-install>this link</a> to install Ansible on your local computer

### 2 - Setup - Download dependencies:
1. Run the command <code>ansible-galaxy install -f -r roles/requirements.yml</code>

### 3 - Running the playbook:
1. Go to hosts.yml and fill in with your instance's IP (from previous step) and SSH key path
2. Use the example on how_to_run.sh to check if you want to change any variable, and run the playbook

## Customizable variables:

The following variables can be customized for your Hana installation. Change them on your local how_to_run.sh

Variable | Description | Default Value
--- | --- | ---
EC2_HOSTNAME | The hostname to be applied on the instance | demo
PRIVATE_DNS_ZONE | Private DNS Zone to be applied on the instance | sap-demo.com
MASTER_PASSWORD | The master password for Hana installation | P@ssw0rd
EFS_ID | The EFS ID to attach to this instance that will hold installation files | fs-xxxxxxxx
ENABLE_HA | Enable High Availability for this installation or not | true
S3_BUCKET_MEDIA_FILES | Path on S3 to download Hana installation binaries | s3://sapgspdemo-sap-binaries-demo/HANA
ASCS_PRIVATE_IP | Main ASCS private IP to be added to /etc/hosts | 172.0.0.0
ASCS_HOSTNAME | Main ASCS hostname to be added to /etc/hosts | demo-ascs
PAS_PRIVATE_IP | PAS private IP to be added to /etc/hosts | 172.0.0.0
PAS_HOSTNAME | PAS hostname to be added to /etc/hosts | demo-pas
PAS_SID | The SID for PAS instance to be installed | AD0
ERS_PRIVATE_IP | Private IP of ERS instance | 172.0.0.1
ERS_HOSTNAME | ERS hostname to be added to /etc/hosts | demo-ers
HANA_SID | The SID for the Hana Installation | AD0
HANA_INSTANCE_NUMBER | The SAP instance number for Hana instance | 00
HANA_PRIVATE_IP | Hana's database private IP | 172.0.0.0
HANA_HOSTNAME | Hana's database hostname | demo-hana
HA_PRIMARY_PRIVATE_IP | Private IP of the primary instance (ASCS server) | 172.0.0.1
HA_NODE_PRIVATE_IPS | Private IPs of other HA instances (ERS server) | 172.0.0.1,

IMPORTANT! This playbook reboots the destined instance, and therefore cannot be run on localhost