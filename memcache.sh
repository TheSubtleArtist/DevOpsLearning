#!/bin/bash
sudo dnf install epel-release -y
sudo dnf install memcached -y
sudo systemctl start memcached
sudo systemctl enable memcached
sudo systemctl status memcached
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached
sudo systemctl restart memcached
firewall-cmd --add-port=11211/tcp --zone=public --permanent
firewall-cmd --add-port=11111/udp --zone=public --permanent
firewall-cmd --reload
sudo memcached -p 11211 -U 11111 -u memcached -d
sudo systemctl restart memcached
