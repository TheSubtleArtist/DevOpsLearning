#!/bin/bash

echo "Jenkins"
echo "Update"
sudo apt-get update -y >/dev/null
echo "Install Dependencies"
sudo apt-get install fontconfig openjdk-11-jdk
sudo apt-get install git maven -y >/dev/null
echo "Keyrings"
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
echo "Install Jenkins"
sudo apt-get install jenkins -y
sudo apt-get install -y software-properties-common
# Install Ansible
echo "Install Ansible"
sudo apt update -y 
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
echo "Update"
echo "y" | sudo ufw enable
sudo ufw allow 8080/tcp
sudo ufw allow 22/tcp
sudo ufw allow ssh
sudo ufw reload