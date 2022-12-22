#!/bin/bash

# DATA NODE SETUP
# source: https://www.digitalocean.com/community/tutorials/how-to-create-a-multi-node-mysql-cluster-on-ubuntu-18-04

cd ~;

# installing all the dependencies
apt-get update -y;
apt-get install sysbench -y;
apt-get install libclass-methodmaker-perl -y;

touch confirms.ini;
wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster-community-data-node_7.6.6-1ubuntu18.04_amd64.deb;
sudo dpkg -i mysql-cluster-community-data-node_7.6.6-1ubuntu18.04_amd64.deb;

touch /etc/my.cnf;
echo "[mysql_cluster]" >> /etc/my.cnf;
echo "ndb-connectstring=ip-172-31-81-1.ec2.internal" >> /etc/my.cnf;  # location of cluster manager.
source /etc/my.cnf;

mkdir -p /usr/local/mysql/data;

mkdir -p /etc/systemd/system/;
touch /etc/systemd/system/ndbd.service;

echo "[Unit]" >> /etc/systemd/system/ndbd.service;
echo "Description=MySQL NDB Data Node Daemon" >> /etc/systemd/system/ndbd.service;
echo "After=network.target auditd.service" >> /etc/systemd/system/ndbd.service;
echo "[Service]" >> /etc/systemd/system/ndbd.service;
echo "Type=forking" >> /etc/systemd/system/ndbd.service;
echo "ExecStart=/usr/sbin/ndbd" >> /etc/systemd/system/ndbd.service;
echo "ExecReload=/bin/kill -HUP $MAINPID" >> /etc/systemd/system/ndbd.service;
echo "KillMode=process" >> /etc/systemd/system/ndbd.service;
echo "Restart=on-failure" >> /etc/systemd/system/ndbd.service;
echo "[Install]" >> /etc/systemd/system/ndbd.service;
echo "WantedBy=multi-user.target" >> /etc/systemd/system/ndbd.service;
source /etc/systemd/system/ndbd.service;

systemctl daemon-reload;
systemctl enable ndbd;
systemctl start ndbd;
systemctl status ndbd >> confirms.ini;




