#!/bin/bash
#jenkins:jenkinspassword123
BACKUPFILE='24-bkp-jenkins.tar.gz'
sudo systemctl stop jenkins

sudo rm -rf /var/lib/jenkins/.m2/*
sudo rm -rf /var/lib/jenkins/workspace/*
sudo rm -rf /var/lib/jenkins/.sonar
cd /var/lib
sudo tar -czvf $BACKUPFILE jenkins
sudo cp $BACKUPFILE /vagrant
sudo systemctl start jenkins