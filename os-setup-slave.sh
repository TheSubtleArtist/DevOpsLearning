#!/bin/bash
sudo apt update -y
sudo apt-get upgrade -y

sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart sshd