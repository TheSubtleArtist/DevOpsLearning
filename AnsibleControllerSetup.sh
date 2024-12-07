#!/bin/bash

sudo apt update -y
sudo apt-get install -y unzip git 

sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible



sudo apt-get install -y python3-boto3 python3-botocore python3-boto vim
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

echo 'y' | sudo ufw enable
sudo ufw allow 22/tcp
sudo ufw reload

