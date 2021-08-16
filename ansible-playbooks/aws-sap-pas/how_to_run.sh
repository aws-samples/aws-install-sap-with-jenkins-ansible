HOSTS_INI_PATH=hosts_local.yml
varFile=var_file.yaml
ANSIBLE_HOST_KEY_CHECKING=False

sudo ansible-playbook -c paramiko site.yml \
            --inventory-file $HOSTS_INI_PATH \
            --extra-vars "@$varFile"