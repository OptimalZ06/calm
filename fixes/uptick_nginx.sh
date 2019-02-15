####################
# Install NGINX
####################
#!/bin/bash
set -ex

sudo adduser nucalm
echo "nucalm" | sudo passwd --stdin nucalm 

# Install Stuff
sudo yum update -y
sudo yum -y install epel-release
sudo yum -y install nginx
sudo yum install -y git
sudo systemctl start nginx

# Make Dir
sudo mkdir -p /var/www/projects/uptick/

# Get Clone
sudo git clone https://github.com/OptimalZ06/uptick.git
cd uptick/

# Move repo files
sudo mv -f * /usr/share/nginx/html/

# Set Permissions
sudo chmod -R 755 /usr/share/nginx/html/
cd /usr/share/nginx/html/

## EDIT js/data.js
#var url = "http://NODE_SERVER_IP_ADDDRESS:3000/api/";
sudo sed -i 's/Current_Cloud/@@{WHICH_CLOUD}@@/' index.html
sudo sed -i 's,Cloud_Icon,@@{CLOUD_ICON}@@,g' index.html
sudo sed -i 's/Currently_running_on/Currently running on @@{WHICH_CLOUD}@@/' index.html
sudo sed -i 's/NODE_SERVER_IP_ADDRESS/@@{AHVNodeJSVM.address}@@/' js/data.js

# Disable SE Linux
sudo setenforce 0

# Start NGINX
sudo systemctl enable nginx
sudo systemctl start nginx
