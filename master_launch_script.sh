#!/bin/bash

apt-get update
apt-get install libaio1 -y
apt-get install libmecab2 -y
apt-get install sysbench -y
apt-get install libncurses5 -y
apt-get install libtinfo5 -y
apt-get install unzip -y


# MASTER NODE SETUP
# source: https://www.digitalocean.com/community/tutorials/how-to-create-a-multi-node-mysql-cluster-on-ubuntu-18-04

cd ~
touch confirms.ini
wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster-community-management-server_7.6.6-1ubuntu18.04_amd64.deb
dpkg -i mysql-cluster-community-management-server_7.6.6-1ubuntu18.04_amd64.deb

mkdir -p /var/lib/mysql-cluster
touch /var/lib/mysql-cluster/config.ini

echo "[ndbd default]" >> /var/lib/mysql-cluster/config.ini
echo "NoOfReplicas=3" >> /var/lib/mysql-cluster/config.ini

# master
echo "[ndb_mgmd]" >> /var/lib/mysql-cluster/config.ini
echo "hostname=ip-172-31-81-1.ec2.internal" >> /var/lib/mysql-cluster/config.ini
echo "NodeId=1" >> /var/lib/mysql-cluster/config.ini
echo "datadir=/var/lib/mysql-cluster"  /var/lib/mysql-cluster/config.ini

# slave 1
echo "[ndbd]" >> /var/lib/mysql-cluster/config.ini
echo "hostname=ip-172-31-81-2.ec2.internal" >> /var/lib/mysql-cluster/config.ini
echo "NodeId=2" >> /var/lib/mysql-cluster/config.ini
echo "datadir=/usr/local/mysql/data" >> /var/lib/mysql-cluster/config.ini

# slave 2
echo "[ndbd]" >> /var/lib/mysql-cluster/config.ini
echo "hostname=ip-172-31-81-3.ec2.internal" >> /var/lib/mysql-cluster/config.ini
echo "NodeId=3" >> /var/lib/mysql-cluster/config.ini
echo "datadir=/usr/local/mysql/data" >> /var/lib/mysql-cluster/config.ini

# slave 3
echo "[ndbd]" >> /var/lib/mysql-cluster/config.ini
echo "hostname=ip-172-31-81-4.ec2.internal" >> /var/lib/mysql-cluster/config.ini
echo "NodeId=4" >> /var/lib/mysql-cluster/config.ini
echo "datadir=/usr/local/mysql/data" >> /var/lib/mysql-cluster/config.ini

echo "[mysqld]" >> /var/lib/mysql-cluster/config.ini
echo "hostname=ip-172-31-81-1.ec2.internal" >> /var/lib/mysql-cluster/config.ini

source /var/lib/mysql-cluster/config.ini

ndb_mgmd -f /var/lib/mysql-cluster/config.ini >> confirms.ini
pkill -f ndb_mgmd

mkdir -p /etc/systemd/system/
touch /etc/systemd/system/ndb_mgmd.service

echo "[Unit]" >> /etc/systemd/system/ndb_mgmd.service
echo "Description=MySQL NDB Cluster Management Server" >> /etc/systemd/system/ndb_mgmd.service
echo "After=network.target auditd.service" >> /etc/systemd/system/ndb_mgmd.service

echo "[Service]" >> /etc/systemd/system/ndb_mgmd.service
echo "Type=forking" >> /etc/systemd/system/ndb_mgmd.service
echo "ExecStart=/usr/sbin/ndb_mgmd -f /var/lib/mysql-cluster/config.ini" >> /etc/systemd/system/ndb_mgmd.service
echo "ExecReload=/bin/kill -HUP $MAINPID" >> /etc/systemd/system/ndb_mgmd.service
echo "KillMode=process" >> /etc/systemd/system/ndb_mgmd.service
echo "Restart=on-failure" >> /etc/systemd/system/ndb_mgmd.service

echo "[Install]" >> /etc/systemd/system/ndb_mgmd.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/ndb_mgmd.service

source /etc/systemd/system/ndb_mgmd.service

systemctl daemon-reload
systemctl enable ndb_mgmd
systemctl start ndb_mgmd
systemctl status ndb_mgmd >> confirms.ini

# allowing connections from data nodes
ufw allow from 172.31.81.2
ufw allow from 172.31.81.3
ufw allow from 172.31.81.4




