# AWS-SAP-ASCS-HANA-PAS-POST-INSTALL

```
Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
SPDX-License-Identifier: MIT-0
```

This repo contains the ansible code for post-install tasks around HANA, ASCS and PAS

## How to run: 

### 1 - Requirements

1. Follow <a href=https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#selecting-an-ansible-artifact-and-version-to-install>this link</a> to install Ansible on your local computer

### 2 - Running the playbook:
1. Go to hosts.yml and fill in with your instance's IP (from previous step) and SSH key path
2. Use the example on how_to_run.sh to check if you want to change any variable, and run the playbook

## Customizable variables:

The following variables can be customized for your Hana installation. Change them on your local how_to_run.sh

Variable | Description | Default Value
--- | --- | ---
INPUT_DNS_ZONE_NAME | Private DNS Zone to be applied on the instance | sap-demo.com