#!/bin/bash

#Begins at the conclusion of the post-installation steps
sudo apt-get install -y tar
BACKUPFILE="bkp-jenkins.tar.gz"
sudo systemctl stop jenkins
sudo cp /vagrant/$BACKUPFILE .
sudo tar xzvf $BACKUPFILE
sudo cp -R jenkins/* /var/lib/jenkins/
sudo chown -R jenkins:jenkins /var/lib/jenkins
sudo systemctl start jenkins

