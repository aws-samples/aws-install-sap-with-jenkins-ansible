HOSTS_INI_PATH=hosts_local.yaml
ANSIBLE_HOST_KEY_CHECKING=False

sudo ansible-playbook main.yaml \
            --inventory-file $HOSTS_INI_PATH \
            --extra-vars "@var_file.yaml"