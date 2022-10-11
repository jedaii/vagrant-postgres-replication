#!/bin/bash
POSTGRES_CONF='/etc/postgresql/11/main/postgresql.conf'

sudo systemctl stop postgresql
# allow connections for user postgres from master VM
sudo sed -i "/^# .*listen on a non-local/a host replication postgres ${MASTER_IP}\/24 md5" /etc/postgresql/11/main/pg_hba.conf
# allow listen connections on address $REPLICA_IP and set other settings for replication
sudo sed -i "s/.*listen_addresses.*/listen_addresses = 'localhost, ${REPLICA_IP}'/" $POSTGRES_CONF
sudo sed -e "s/.*wal_level.*/wal_level = hot_standby/" \
         -e "s/.*archive_mode.*/archive_mode = on/" \
         -e "s/.*archive_command.*/archive_command = 'cd .'/" \
         -e "s/.*max_wal_senders.*/max_wal_senders = 8/" \
         -e "s/.*hot_standby.*/hot_standby = on/" -i $POSTGRES_CONF

# removing default db catalog and preparing it for db from master node
cd /var/lib/postgresql/11/
sudo rm -rf main; sudo mkdir main; sudo chown postgres:postgres main; sudo chmod go-rwx main

# sudo echo "192.168.56.10:5432:*:postgres:password" > /var/lib/postgresql/11/.pgpass
# sudo chown postgres:postgres /var/lib/postgresql/11/.pgpass
# sudo chmod 0600 /var/lib/postgresql/11/.pgpass
# echo "export PGPASSFILE=/var/lib/postgresql/11/.pgpass" | sudo tee /etc/profile.d/pgpass.sh

# taking base backup from master
sudo -u postgres pg_basebackup -P -R -X stream -c fast -h ${MASTER_IP} -U postgres -D ./main

sudo systemctl start postgresql