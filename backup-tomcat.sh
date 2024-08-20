#!/bin/bash
sudo systemctl stop tomcat
sudo cp /usr/local/tomcat8/conf/tomcat-users.xml /vagrant
sudo cp /usr/local/tomcat8/webapps/manaager/META-INF/context.xml /vagrant
sudo systemctl start tomcat
