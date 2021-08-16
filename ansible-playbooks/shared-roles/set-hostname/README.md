# Set Hostname Ansible role

```
Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
SPDX-License-Identifier: MIT-0
```

This is an Ansible role containing the "Set Hostname" shared role that other playbooks use to install components of the SAP ecosystem

Its purpose is to set the appropriate <code>hostname</code> and <code>/etc/hosts</code> configuration on the hosting OS in preparation of SAP installation

# Role's tasks:

1. Set instance hostname
2. Add hostname to cloud.cfg file
3. Register own hostname to /etc/hosts file
4. Register other user given hostnames to /etc/hosts file

# Available variables:

Variable name | Required? | Description | Example
--- | --- | --- | ---
extra_vars_to_add_to_hosts | No | Extra map of variables "private_ip" and "hostname" to add to /etc/hosts file | <code>- private_ip: 172.0.0.0<br/>hostname: demo-host</code>

## How to use

On your main <code>.yml</code> file add:

Example 1 - adding other hosts to <code>/etc/hosts</code> file: 

```
- name: Set hostname
  become: yes
  hosts: all
  roles:
    - role: set-hostname
      vars:
        extra_vars_to_add_to_hosts:
          - private_ip: "172.0.0.1"
            hostname: "ascs-demo"
          - private_ip: "172.0.0.2"
            hostname: "pas-demo"
```

Example 2 - with no extra vars: 

```
- name: Set hostname
  become: yes
  hosts: all
  roles:
    - role: set-hostname
```

## Sample output

During run time on your Ansible output you should see an image like the one below in case you've used the first example approach:

![Example output](readme_images/example_output.png)