# AWS - Install SAP with Jenkins and Ansible

```
Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
SPDX-License-Identifier: MIT-0
```

This is an open source repo with sample code to install your SAP Software (check availability below) using Jenkins to connect all the pipeline steps, Ansible for configuring the operating system level, and Terraform for spinning up the infrastructure.

You can check how to use this repo on this blog post: <insert blog post here>

SAP Software available:
* SAP Hana - SAP In-Memory Database (HA is available)
* SAP ASCS - ABAP Central Services (HA is available)
* SAP ERS - Enqueue Replication Service (installed when HA is set for ASCS)
* SAP PAS - Primary Application Server

All the folders highlighted below can be separated into their own repositories. Check out the README on each one of them to understand in-depth their reponsibility:

```
|-- InstallSAPWithJenkinsAnsible
|   |-- ansible-playbooks (playbooks for installing ASCS, Hana and PAS, and also shared roles)
|   |   |-- aws-sap-ascs
|   |   |-- aws-sap-hana
|   |   |-- aws-sap-pas
|   |   |-- shared-roles (roles that are shared between the three above playbooks)
|   |   |   |-- check-inputs
|   |   |   |-- common-os-tasks
|   |   |   |-- install-aws-sap-data-provider
|   |   |   |-- install-pkg-mgr-dependencies
|   |   |   |-- prepare-logs-folders
|   |   |   |-- set-hostname
|   |-- jenkins-as-code (your whole Jenkins installation code)
|   |-- jenkins-pipelines (pipelines that are going to be run by Jenkins)
|   |   |-- sap-pipeline-destroy-hana-pas-ascs
|   |   |-- sap-pipeline-hana-pas-ascs
```

Terraform code used by this repo is available here: https://github.com/aws-samples/terraform-aws-sap-netweaver-on-hana

## Requirements

For running this project you have to have installed the following software on your local computer:
* Vagrant - https://www.vagrantup.com/
* Oracle VirtualBox - https://www.virtualbox.org/

## How to start - high level:

1. Have a Bucket on S3 with all the SAP Software-related media you're going to need. Follow the <a href="https://docs.aws.amazon.com/launchwizard/latest/userguide/launch-wizard-sap-software-install-details.html">instructions on which file to place on which folder here.</a>
2. Go to Jenkins as Code folder and follow the README:
    1. ```sudo vagrant up```
    2. Go to ```http://localhost:5555``` and login using "admin/my_secret_pass_from_vault" as user/password
    3. Fill in your AWS account credentials and other required variables
    4. Trigger pipeline "Install HANA+PAS+ASCS"

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.