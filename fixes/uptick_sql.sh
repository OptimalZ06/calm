#!/bin/bash
set -ex

### Mysql installation
# Download MySQL & install wget
sudo yum install -y wget
wget https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm

# Update
#sudo yum update -y

# Install MySQL
sudo rpm -ivh mysql80-community-release-el7-1.noarch.rpm
sudo yum install -y mysql-server
sudo systemctl start mysqld

# Start MySQL daemon & enable it
sudo systemctl start mysqld
sudo systemctl enable mysqld

# Create DB folder
sudo mkdir -p /var/uptick/database/mysql/
cd /var/uptick/database/mysql/

### Upload existing database
# Install wget via yum
sudo yum -y install wget

# Download uptick database
sudo wget https://raw.githubusercontent.com/OptimalZ06/uptick/master/databases/mysql/uptick.database.sql

#Fix to obtain temp password and set to @@{MYSQL_PASSWORD}@@ variable {Calm}
password=$(grep -oP 'temporary password(.*): \K(\S+)' /var/log/mysqld.log | awk '{print $NF}')
mysqladmin -u root --password="$password" password "@@{MYSQL_PASSWORD}@@"
mysql -u root --password="@@{MYSQL_PASSWORD}@@" -e "UNINSTALL COMPONENT 'file://component_validate_password'"
#mysql -u root --password="@@{MYSQL_PASSWORD}@@"
#mysqladmin -u root --password="aaBB**cc1122" password "@@{MYSQL_PASSWORD}@@"

# Mysql secure installation {Calm}
mysql -u root --password="@@{MYSQL_PASSWORD}@@"<<-EOF
create database Uptick;
CREATE USER 'root'@'%' IDENTIFIED BY '@@{MYSQL_PASSWORD}@@';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '@@{MYSQL_PASSWORD}@@';
use Uptick;
source /var/uptick/database/mysql/uptick.database.sql;
FLUSH PRIVILEGES;
EOF

# Restart MySQL service
sudo systemctl restart mysqld
