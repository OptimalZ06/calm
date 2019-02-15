####################
# Install NODEJS
####################
curl --silent --location https://rpm.nodesource.com/setup_9.x | sudo bash -

# Yum Installs
#sudo yum -y install epel-release
sudo yum -y install nodejs
#sudo yum update -y
sudo yum install -y git

# Setup firewall
sudo yum install -y firewalld
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --permanent --zone=public --add-port=3000/tcp
sudo systemctl restart firewalld

# Make Dir
sudo mkdir -p /var/www/projects/uptick
cd /var/www/projects

# Clone repo
sudo git clone https://github.com/OptimalZ06/uptick.git

# Set permisisons
sudo chmod -R 755 uptick/
cd uptick/

# disable se linux
sudo setenforce 0

# Edit config/mssqlConfig.js
sudo sed -i 's/DB_SERVER_IPADDRESS/@@{MYSQL.address}@@/' config/mysqlConfig.js
sudo sed -i 's/DB_USER/@@{MYSQL_USERNAME}@@/' config/mysqlConfig.js
sudo sed -i 's/DB_PASSWORD/@@{MYSQL_PASSWORD}@@/' config/mysqlConfig.js
sudo sed -i 's/DB_NAME/@@{MYSQL_DB}@@/' config/mysqlConfig.js

# Build script and install forever
sudo npm install forever -g
sudo npm build

forever start server.js

#sudo systemctl restart httpd
#sudo systemctl enable httpd
