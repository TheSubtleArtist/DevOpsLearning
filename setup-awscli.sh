#/bin/bash

wget "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -O "awscliv2.zip"
unzip awscliv2.zip > /dev/null
sudo ./aws/install

aws configure