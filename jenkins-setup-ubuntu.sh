#!/bin/bash
apt-get update

echo "INSTALL GIT and MAVEN"
sudo apt-get install -y git maven 


sudo apt update
echo "FONTCONFIG OPENJDK 17"
sudo apt install -y fontconfig openjdk-8-jre 
java -version

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list
sudo apt-get update -y
echo "JENKINS"
sudo apt-get install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins

# Install Ansible
echo "Install Ansible"
add-apt-repository --yes --update ppa:ansible/ansible
apt update -y >/dev/null
apt-get install ansible -y
echo "Update"
apt-get upgrade -y >/dev/null
echo "y" | sudo ufw enable
ufw allow 8080/tcp
ufw allow ssh
ufw reload
ufw status

