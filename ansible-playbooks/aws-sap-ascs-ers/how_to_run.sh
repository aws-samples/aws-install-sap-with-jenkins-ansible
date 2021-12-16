HOSTS_INI_PATH=hosts_local.yml
ANSIBLE_HOST_KEY_CHECKING=False

sudo ansible-playbook site.yml \
            --inventory-file $HOSTS_INI_PATH \
            --extra-vars "@var_file.yaml"