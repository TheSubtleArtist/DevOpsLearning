#!/bin/bash

# ROCKY 8

sudo dnf install epel-release -y
sudo dnf install -y memcached libmemcached
sudo dnf update -y
sudo systemctl start memcached
sudo systemctl enable memcached
#sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached
sudo systemctl restart memcached
sudo firewall-cmd --add-port=11211/tcp --zone=public --permanent
sudo firewall-cmd --add-port=11111/udp --zone=public --permanent
sudo firewall-cmd --reload
sudo memcached -p 11211 -U 11111 -u memcached -d
sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached
sudo systemctl restart memcached
sudo systemctl status memcached