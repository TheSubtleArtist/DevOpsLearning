#!/bin/bash
sudo systemctl stop tomcat
BACKUPFILE="24-bkp-tomcat-staging-ubuntu.tgz"
cp /usr/local/
sudo tar -czvf $BACKUPFILE tomcat8
cp $BACKUPFILE /vagrant
sudo systemctl start tomcat