#!/bin/bash
# personally edited for rocky 8
sudo yum install wget epel-release curl -y
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

sudo dnf update -y
sudo dnf install socat logrotate -y
sudo dnf install -y erlang rabbitmq-server

systemctl enable --now rabbitmq-server
systemctl start rabbitmq-server
firewall-cmd --add-port=5672/tcp --zone=public --permanent
firewall-cmd --reload

sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator
sudo systemctl restart rabbitmq-server

# Comment
