#!/bin/bash
###KUBEMASTER###

#System Settings
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system

lsmod | grep br_netfilter
lsmod | grep overlay

sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward

sudo apt update -y

# Add Docker's official GPG key:
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y

# Install Latest Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y



#Installing Kubeadm, Kubelet & Kubectl#
KUBEVERSION=v1.30
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet

sleep 12
echo "Waiting for 120 Seconds...."
echo "Lets initialize."

IPADDR=192.168.33.2
POD_CIDR=10.244.0.0/16
NODENAME=kubemaster
#kubeadm init --pod-network-cidr 10.244.0.0/16  --apiserver-advertise-address=192.168.33.2 > /tmp/kubeinitout.log
kubeadm init --control-plane-endpoint=$IPADDR    --pod-network-cidr=$POD_CIDR --node-name $NODENAME --ignore-preflight-errors Swap &>> /tmp/initout.log
sleep 60

# Ouptut join command
sleep 20
tail -2 /tmp/initout.log > /vagrant/cltjoincommand.sh



echo 'y' | sudo ufw enable
sudo ufw allow 22/tcp
sudo ufw reload

# Verify Successful Installation
sudo usermod -aG docker $USER
sudo docker run hello-world