#!/bin/bash

sudo yum install wget epel-release curl -y

sudo curl -s https://github.com/rabbitmq/erlang-rpm/releases/download/v26.2.5.2/erlang-26.2.5.2-1.el7.x86_64.rpm
sudo curl -s https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.13.5/rabbitmq-server-3.13.5-1.el8.noarch.rpm


sudo dnf update -y
sudo dnf install socat logrotate -y
sudo dnf install -f erlang-26.2.5.2-1.el7.x86_64.rpm
sudo dnf install -f rabbitmq-server-3.13.5-1.el8.noarch.rpm

systemctl enable --now rabbitmq-server
systemctl start rabbitmq-server
firewall-cmd --add-port=5672/tcp --zone=public --permanent
firewall-cmd --reload

sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator
sudo systemctl restart rabbitmq-server