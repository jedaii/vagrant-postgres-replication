#!/bin/bash
POSTGRES_CONF='/etc/postgresql/11/main/postgresql.conf'

sudo -u postgres psql -U postgres -d postgres -c "ALTER ROLE postgres PASSWORD 'password'"

sudo -u postgres psql -U postgres -c "create database ${DBNAME};"
sudo -u postgres psql -U postgres -c "create user ${DBUSER} with password '${DBPASSWORD}';"
sudo -u postgres psql -U postgres -c "grant all privileges on database ${DBNAME} to ${DBUSER};"

sudo sed -i "/^# .*listen on a non-local/a host replication postgres ${REPLICA_IP}\/24 trust" /etc/postgresql/11/main/pg_hba.conf
sudo sed -i "/.*host replication postgres/a host all ${DBUSER} 192.168.56.100/24 md5" /etc/postgresql/11/main/pg_hba.conf
sudo sed -i "s/.*listen_addresses.*/listen_addresses = 'localhost, ${MASTER_IP}'/" $POSTGRES_CONF
sudo sed -i "s/.*wal_level.*/wal_level = hot_standby/" $POSTGRES_CONF
sudo sed -i "s/.*archive_mode.*/archive_mode = on/" $POSTGRES_CONF
sudo sed -i "s/.*archive_command.*/archive_command = 'cd .'/" $POSTGRES_CONF
sudo sed -i "s/.*max_wal_senders.*/max_wal_senders = 8/" $POSTGRES_CONF
sudo sed -i "s/.*hot_standby.*/hot_standby = on/" $POSTGRES_CONF
sudo systemctl restart postgresql