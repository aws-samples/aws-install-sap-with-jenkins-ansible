HOSTS_INI_PATH=hosts_local.yml
ANSIBLE_HOST_KEY_CHECKING=False

sudo ansible-playbook site.yml \
            --inventory-file $HOSTS_INI_PATH \
            --extra-vars "EC2_HOSTNAME=demo-ascs \
                            PRIVATE_DNS_ZONE=sapgspteam.net \
                            MASTER_PASSWORD=P@ssw0rd \
                            ASCS_SID=AD0 \
                            EFS_ID=fs-59d459ed \
                            ASCS_INSTANCE_NUMBER=00 \
                            HANA_PRIVATE_IP=172.31.13.33 \
                            HANA_HOSTNAME=demo-hana \
                            S3_BUCKET_MEDIA_FILES=s3://sapgspdemo-sap-binaries-lw/S4H1909 \
                            PAS_PRIVATE_IP=172.31.15.158 \
                            PAS_HOSTNAME=demo-pas"