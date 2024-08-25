#!/bin/bash

#admin:admin
BACKUPFILE="24-bkp-sonarqube.tgz"
sudo systemctl stop postgresql
sudo systemctl stop sonarqube
cd /opt
sudo tar -czvf $BACKUPFILE sonarqube
sudo cp $BACKUPFILE /vagrant
sudo systemctl start sonarqube