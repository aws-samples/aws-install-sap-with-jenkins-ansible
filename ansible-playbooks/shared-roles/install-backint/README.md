# Install Backint Ansible role

This is an Ansible playbook containing the "Install Backint" shared role that other playbooks use to install components of the SAP ecosystem

It has one main purposes:

1. Install AWS Backint agent (https://aws.amazon.com/pt/backint-agent/) to automate backups of Hana instances

# Available variables:

Variable name | Required? | Description | Example
--- | --- | --- | ---
GLOBAL_INSTALL_BACKINT | No | Whether Backint must be installed or not (run this role) | yes
GLOBAL_HANA_SHARED_FOLDER | No | The folder where Hana is installed on this instance. Default value is /hana/shared | /hana/shared
GLOBAL_BUCKET_TO_BACKUP | Yes | The bucket name to where Backint backup data must be sent | sap-my-backup-bucket
GLOBAL_AWS_REGION | Yes | Region for the bucket | us-east-1
GLOBAL_HANA_SID | Yes | This instance's Hana's SID | HD0

IMPORTANT! Backint uses the "Bucket owner ID" which is the AWS Account Owner ID to install itself. This role is retrieving it from current user's AWS CLI and forward it to Backint installer

## How to use

On your main .yml file add:

```
- name: Install Backint
  become: yes
  hosts: all
  roles:
    - role: ansible-role-install-backint
      vars:
        GLOBAL_INSTALL_BACKINT: yes
        GLOBAL_HANA_SHARED_FOLDER: "/hana/shared"
        GLOBAL_BUCKET_TO_BACKUP: sap-my-backup-bucket
        GLOBAL_AWS_REGION: "us-east-1"
        GLOBAL_HANA_SID: "HDB"
```

## Project examples how to use it

Check the following project examples on how to use this role:

* <a href=https://gitlab.aws.dev/sap-devops/configuration-management/ansible/aws-sap-hana>Installing SAP Hana</a>