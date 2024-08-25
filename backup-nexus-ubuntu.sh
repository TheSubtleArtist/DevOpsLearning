#!/bin/bash

#admin:nexuspassword123

NEXUSBACKUP="24-bkp-nexus.tgz"
sudo systemctl stop nexus
cd /opt
sudo tar -czvf $NEXUSBACKUP nexus
sudo cp $NEXUSBACKUP /vagrant

sudo systemctl start nexus