#!/bin/bash

#admin:nexuspassword123

NEXUSBACKUP="bkp-nexus.tgz"
sudo systemctl stop nexus
cp /vagrant/$NEXUSBACKUP .
sudo tar xzvf $NEXUSBACKUP nexus
sudo cp -R nexus/* /opt/nexus3

sudo systemctl start nexus