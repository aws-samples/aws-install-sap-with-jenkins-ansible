#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# ------------------------------------------------------------------
# Grab data from Terraform
# ------------------------------------------------------------------
if [ -z "$ANSIBLE_DIR" ]; then
    echo "No Ansible playbook dir was found as reference. Please check again"
    exit 100
fi

if [ -z "$SSH_KEYPAIR_FILE_CHKD" ]; then
    echo "No KeyPair file param was found. Please check again"
    exit 100
fi

if [ -z "$HOSTS_IPS" ]; then
    echo "No Hosts IPs were received as input params"
    exit 100
fi

public_ips_values=$(echo $HOSTS_IPS | sed "s/\[/\ /g" | sed "s/\]/\ /g" | sed "s/\,/\ /g")
eval "public_ips_array=($public_ips_values)"

# ------------------------------------------------------------------
# Create hosts_runtime.yml
# ------------------------------------------------------------------
hostsFile="$ANSIBLE_DIR/hosts_runtime.yml"

rm $hostsFile 2> /dev/null
touch $hostsFile

echo "---" >> $hostsFile
echo "" >> $hostsFile
echo "all:" >> $hostsFile
echo "  hosts:" >> $hostsFile

for instance_ip in "${public_ips_array[@]}"; do 
    echo "Adding $instance_ip to $hostsFile"
    echo "    $instance_ip:" >> $hostsFile
    echo "      ansible_host: $instance_ip" >> $hostsFile
    echo "      ansible_port: 22" >> $hostsFile
    echo "      ansible_user: ec2-user" >> $hostsFile
    echo "      ansible_connection: ssh" >> $hostsFile
    echo "      ansible_ssh_private_key_file: $SSH_KEYPAIR_FILE_CHKD" >> $hostsFile
    echo "      ansible_ssh_common_args: \"-o StrictHostKeyChecking=no -o ServerAliveInterval=30 -o ControlMaster=auto -o ControlPersist=60s\"" >> $hostsFile
done

exit 0