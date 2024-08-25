#!/bin/bash

sudo apt update 
sudo apt-get install -y unzip git

# INSTALL KUBECTL
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
sudo apt-get install -y bash-completion
echo 'source <(kubectl completion bash)' >>~/.bashrc
kubectl version --client

# INSTALL KOPS
curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops
sudo mv kops /usr/local/bin/kops

# INSTALL HELM
wget https://get.helm.sh/helm-v3.15.4-linux-amd64.tar.gz -O "helm.tar.gz"
sudo tar xzvf helm.tar.gz
sudo cp linux-amd64/helm /usr/local/bin/helm
# INSTALL AWS CLI
wget "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -O "awscliv2.zip"
unzip awscliv2.zip > /dev/null
sudo ./aws/install
