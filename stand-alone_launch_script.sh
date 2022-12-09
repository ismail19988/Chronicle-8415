#!/bin/bash

cd ~

# installing all the dependencies
apt-get update -y
apt-get upgrade -y
apt-get install mysql-server -y
apt-get install unzip -y
apt-get install sysbench -y

# source : https://www.sqliz.com/sakila/installation/
wget http://downloads.mysql.com/docs/sakila-db.zip

# source : https://dev.mysql.com/doc/sakila/en/sakila-installation.html
unzip sakila-db.zip -d /tmp
mysql -e "SOURCE /tmp/sakila-db/sakila-schema.sql;"
mysql -e "SOURCE /tmp/sakila-db/sakila-data.sql;"

# source https://www.digitalocean.com/community/tutorials/how-to-create-a-new-user-and-grant-permissions-in-mysql
mysql -e "CREATE USER 'user'@'localhost' IDENTIFIED BY '0';"
mysql -e "GRANT ALL PRIVILEGES on sakila.* TO 'user'@'localhost';"

# source https://severalnines.com/blog/how-benchmark-performance-mysql-mariadb-using-sysbench/
# running the stand alone benchmark and saving the results
sysbench --db-driver=mysql --mysql-db=sakila --mysql-user=user --mysql_password=0  --table-size=50000 --tables=10 /usr/share/sysbench/oltp_read_write.lua prepare
sysbench --db-driver=mysql --mysql-db=sakila --mysql-user=user --mysql_password=0  --table-size=50000  --tables=10 --threads=4 /usr/share/sysbench/oltp_read_write.lua run > stand-alone_server
