#!/bin/bash

#Rocky 8
yum update -y
yum install httpd wget unzip -y
systemctl start httpd
systemctl enable httpd
cd /tmp
wget https://www.tooplate.com/zip-templates/2137_barista_cafe.zip
unzip -o 2137_barista_cafe.zip
mkdir -p /var/www/html/
cp -r 2137_barista_cafe/* /var/www/html/
systemctl restart httpd
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --add-service=http --permanent --zone=public
sudo firewall-cmd --reload