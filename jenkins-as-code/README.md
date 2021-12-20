# Jenkins toolbox for SAP

```
Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
SPDX-License-Identifier: MIT-0
```

This is a project that deploys a fully configured Jenkins master node (either to Vagrant (locally) or Packer (AWS AMI)) and has the following pipelines ready to be built on customers:
* <b>SAP Hana+ASCS+PAS 3 Instances</b> - Spin up 3 instances on AWS and install each of Hana, ASCS and PAS on each of ths instances
* <b>Destroy SAP Hana+ASCS+PAS 3 Instances</b> - Destroy the environment created on the item above

### If you want to understand better the layers covered by this code, extend, modify, update or make any changes to this repo, please read "CUSTOMIZING_THIS_REPO.md" beforehand to understand how it works.

## 1. How to Run

### Running locally with Vagrant

Vagrantfile is used to local tests only. This is a simple alternative to test your code locally (faster) before creating the image on AWS cloud with Packer

If you don't want to run it locally and want to run from AWS, go to Packer section

#### Vagrant commands:

1. Have (1) <a href="https://learn.hashicorp.com/tutorials/vagrant/getting-started-install" target="_blank">Vagrant installed</a> and (2) <a href="https://www.virtualbox.org/wiki/Downloads" target="_blank">Oracle's VirtualBox</a>
2. How to run: navigate to jenkins-as-code folder and run <code>sudo vagrant up</code>. After everything is complete, it will create a Jenkins acessible from your host machine at <code>http://localhost:5555</code>
3. How to SSH into the created machine: run <code>sudo vagrant ssh</code>
4. How to destroy the VM: run <code>sudo vagrant destroy</code>

### Allowing your PC to connect to the instances to be created by Terraform

1. Allow your own IP to SSH using port 22 in your default security group (the default security group will be asked on Jenkins params).

### Adding required credentials to Jenkins and running your pipelines (installing SAP)

1. Go to <code>http://localhost:5555</code> and click Login on the top right corner
2. Use <code>admin</code> and <code>my_secret_pass_from_vault</code> as passwords. This can be changed on file <code>ansible_config/roles/ansible-role-jenkins/defaults/main.yml > "jenkins_admin_password"</code>
3. Click Manage Jenkins > Manage Credentials
4. Click on the variable name and then Update (on the left menu), and add the follow information. REQUIRED variables are:

Variable | Description | Example
--- | --- | ---
AWS_ACCOUNT_CREDENTIALS | Your aws_access_key and aws_secret_key as user/password | AAAAAAAAAAAAAAAAAAAA/aA1aA1aA1aA1aA1aA1aA1aA1aA1aA1aA1aA1aA1a
AMI_ID | Your AMI ID of "Red Hat Enterprise Linux for SAP with HA and Update Services 8.2" available on <a href="https://console.aws.amazon.com/marketplace/home?region=us-east-1#/landing">Marketplace</a> | ami-0e459d519030c2bd7
KMS_KEY_ARN | Your KMS Key ARN. This is going to be used to encrypt the different layers of data created by Terraform | Example: arn:aws:kms:region:123456789000:key/00000000-0000-0000-0000-000000000000
SSH_KEYPAIR_NAME | The NAME of your KeyPair, which is going to be used for Ansible to SSH into the instances you're going to create. Get one from the <a href="https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#KeyPairs:">console here</a> | mykeypair
SSH_KEYPAIR_FILE | The actual .pem file to use to SSH into the instances | Get one from the <a href="https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#KeyPairs:">console here</a> | mykeypair.pem
S3_ROOT_FOLDER_INSTALL_FILES | S3 bucket to find SAP software installation media | s3://sapdemo-sap-binaries
PRIVATE_DNS_ZONE_NAME | A private DNS zone name. This is going to be used by SAP Software to send information to one another | sapteam.net
VPC_ID | The ID of the VPC where the infrastructure must be placed in | vpc-aa00aa00
SUBNET_IDS | The Subnet IDs (comma separated) inside the given VPC to spin the instances into | subnet-fec01a98,subnet-1fa23g45
SECURITY_GROUP_ID | A default Security Group ID inside the given VPC to attach to the instances | sg-00aa00aa00aa00aa0

### Other available variables
Variable | Description | Default value
--- | --- | ---
ENABLE_HA | Whether to enable HA for the installation or not (true or false values are accepted) | true 
AWS_REGION | The AWS region to be used | us-east-1
S3_FOLDER_HANA_INSTALL_FILES | S3 folder within the bucket to find Hana installation media | HANA
PRIVATE_DNS_ZONE_NAME | Private DNS Zone to attach installation to | sapgspteam.net
EC2_INSTANCES_NAME_PREFIX | Prefix name for the instances | demo
MASTER_PASSWORD | Master password to be used to all installed software | P@ssw0rd
SAP_SID | SAP SID to be set to ASCS and PAS SAP installations (you cannot change this in the future) | AD0
HANA_SID | The Hana SID to be set to Hana installation (you cannot change this in the future) | AD0
HANA_INSTANCE_TYPE | The instance type to set to Hana instances | r5.4xlarge
ASCS_INSTANCE_TYPE | The instance type to set to ASCS instances | m5.xlarge
PAS_INSTANCE_TYPE | The instance type to set to PAS instances | m5.xlarge
HANA_INSTANCE_NUMBER | The instance number for Hana Software | 00
ASCS_INSTANCE_NUMBER | The instance number for ASCS Software | 00
PAS_INSTANCE_NUMBER | The instance number for PAS Software | 00
APPLICATION_CODE | Application code to be used as tags for your environment | demo-hana
APPLICATION_NAME | Application name to be used as tags for your environment | demo-hana
ENVIRONMENT_TYPE | Environment type to be used as tags for your environment | dev

### Running pipelines

You have the following pipelines available to run (code is available on folder jenkins-pipelines folder in this same repo):

Pipeline Path | Description
--- | ---
SAP Hana+ASCS+PAS 3 Instances > Spin up and Install | It will spin up 3 instances on AWS and install each of PAS, ASCS and Hana on each of them
SAP Hana+ASCS+PAS 3 Instances > Destroy env | Destroy the environment created on the item above