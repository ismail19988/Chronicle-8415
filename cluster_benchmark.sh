# MY SQL SERVER SETUP
# source: https://www.digitalocean.com/community/tutorials/how-to-create-a-multi-node-mysql-cluster-on-ubuntu-18-04
# downloading musql cluster
wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster_7.6.6-1ubuntu18.04_amd64.deb-bundle.tar;
mkdir install;
tar -xvf mysql-cluster_7.6.6-1ubuntu18.04_amd64.deb-bundle.tar -C install/;

# downloading and installing some sql dependencies
cd install;
sudo dpkg -i mysql-common_7.6.6-1ubuntu18.04_amd64.deb;
sudo dpkg -i mysql-cluster-community-client_7.6.6-1ubuntu18.04_amd64.deb;
sudo dpkg -i mysql-client_7.6.6-1ubuntu18.04_amd64.deb;
sudo dpkg -i mysql-cluster-community-server_7.6.6-1ubuntu18.04_amd64.deb;
sudo dpkg -i mysql-server_7.6.6-1ubuntu18.04_amd64.deb;

cd ..;

# creating my.cnf file
mkdir -p /etc/mysql/;
touch /etc/mysql/my.cnf;

# configuring my.cnf file
echo "!includedir /etc/mysql/conf.d/" >> /etc/mysql/my.cnf;
echo "!includedir /etc/mysql/mysql.conf.d/" >> /etc/mysql/my.cnf;

echo "[mysqld]" >> /etc/mysql/my.cnf;
echo "ndbcluster" >> /etc/mysql/my.cnf;

echo "[mysql_cluster]" >> /etc/mysql/my.cnf;
echo "ndb-connectstring=ip-172-31-81-1.ec2.internal" >> /etc/mysql/my.cnf;
source /etc/mysql/my.cnf;

# restarting my sql
systemctl restart mysql;
systemctl enable mysql;

# to show the running nodes
# ndb_mgm -e show

# source : https://www.sqliz.com/sakila/installation/;
# downloading sakila DB
wget http://downloads.mysql.com/docs/sakila-db.zip;

# source : https://dev.mysql.com/doc/sakila/en/sakila-installation.html;
# installing sakila DB
unzip sakila-db.zip -d /tmp;
mysql -e "SOURCE /tmp/sakila-db/sakila-schema.sql;";
mysql -e "SOURCE /tmp/sakila-db/sakila-data.sql;";

# source https://www.digitalocean.com/community/tutorials/how-to-create-a-new-user-and-grant-permissions-in-mysql;
# creating a user with the rights to run the benchmarks
mysql -e "CREATE USER 'user'@'localhost' IDENTIFIED BY '0';";
mysql -e "GRANT ALL PRIVILEGES on sakila.* TO 'user'@'localhost';";

# running the cluster benchmark and saving the results
sudo sysbench --db-driver=mysql --mysql-db=sakila --mysql-user=user --mysql_password=0  --table-size=50000  /usr/share/sysbench/oltp_read_write.lua prepare;
sudo sysbench --db-driver=mysql --mysql-db=sakila --mysql-user=user --mysql-password=0  --table-size=50000  --num-threads=6 --max-time=30 /usr/share/sysbench/oltp_read_write.lua run > cluster_results;