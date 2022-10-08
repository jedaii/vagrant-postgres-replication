#!/bin/bash
POSTGRES_CONF='/etc/postgresql/11/main/postgresql.conf'

sudo systemctl stop postgresql
sudo sed -i '/^# .*listen on a non-local/a host replication postgres 192.168.56.20/24 trust' /etc/postgresql/11/main/pg_hba.conf
sudo sed -i "s/.*listen_addresses.*/listen_addresses = 'localhost, 192.168.56.10'/" $POSTGRES_CONF
sudo sed -i "s/.*wal_level.*/wal_level = hot_standby/" $POSTGRES_CONF
sudo sed -i "s/.*archive_mode.*/archive_mode = on/" $POSTGRES_CONF
sudo sed -i "s/.*archive_command.*/archive_command = 'cd .'/" $POSTGRES_CONF
sudo sed -i "s/.*max_wal_senders.*/max_wal_senders = 8/" $POSTGRES_CONF
sudo sed -i "s/.*hot_standby.*/hot_standby = on/" $POSTGRES_CONF

cd /var/lib/postgresql/11/
sudo rm -rf main; sudo mkdir main; sudo chown postgres:postgres main; sudo chmod go-rwx main

# sudo echo "192.168.56.10:5432:*:postgres:password" > /var/lib/postgresql/11/.pgpass
# sudo chown postgres:postgres /var/lib/postgresql/11/.pgpass
# sudo chmod 0600 /var/lib/postgresql/11/.pgpass
# echo "export PGPASSFILE=/var/lib/postgresql/11/.pgpass" | sudo tee /etc/profile.d/pgpass.sh
sudo -u postgres pg_basebackup -P -R -X stream -c fast -h 192.168.56.10 -U postgres -D ./main

sudo systemctl start postgresql