# Common OS Parameters Ansible role

This is an Ansible role containing the "Common OS Parameters" shared role that other playbooks use to install components of the SAP ecosystem

Its purpose is to apply common OS parameters to prepare for a SAP Installation

1. Install AWS CLI
2. Install SSM Agent (can be deactivated using variable install_ssm as shown in Example 2)
3. Set Timezone

# Roles' tasks:

1. Set timezone

# Available variables:

Variable name | Required? | Description | Example | Default value if variable is not informed
--- | --- | --- | --- | ---
input_custom_timezone | No | Timezone string to be set to Linux OS | Asia/Tokyo | America/Chicago


## How to use

On your main <code>.yml</code> file add:

Example 1:
```
- name: Apply common OS parameters
  become: yes
  hosts: all
  roles:
    - role: common-os-parameters
      vars:
        - input_custom_timezone: America/Chicago
```

Example 2:
```
- name: Apply common OS parameters
  become: yes
  hosts: all
  roles:
    - role: common-os-parameters
      vars:
        - input_custom_timezone: America/Chicago
        - install_ssm: false
```


## Sample output

During run time on your Ansible output you should see an entry like the one below:

![Example output](readme_images/example_output.png)