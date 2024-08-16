#!/bin/bash
###KUBEMASTER###



sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt-get install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
#Install "Latest"

sudo apt-get install -y docker-compose docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo docker run hello-world
sudo usermod -aG docker $USER
docker run hello-world

wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.13/cri-dockerd_0.3.13.3-0.ubuntu-focal_amd64.deb
sudo apt install ./cri-dockerd_0.3.13.3-0.ubuntu-focal_amd64.deb -y 
sudo systemctl status docker.service
sudo systemctl status cri-docker.service

# Set selinux to permissive
#sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config


# Disable Swap
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
free -m

# Enable necessary kernel modules
sudo modprobe overlay
sudo modprobe br_netfilter

# Create script to load modules on every reboot
cat << EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

cat << EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system

lsmod | grep br_netfilter
lsmod | grep overlay

sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward

#Installing Kubeadm, Kubelet & Kubectl#
KUBEVERSION=v1.30
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable kubelet

sleep 12
echo "Waiting for 120 Seconds...."
echo "Lets initialize."

# Start Kubernetes
IPADDR=192.168.33.2
POD_CIDR=10.244.0.0/16
NODENAME=kubemaster
sudo systemctl enable kubelet
sudo kubeadm config images pull  --cri-socket /var/run/cri-dockerd.sock
sudo kubeadm init --pod-network-cidr=$POD_CIDR --node-name $NODENAME --control-plane-endpoint {`hostname --fqdn`,,} --cri-socket /var/run/cri-dockerd.sock --ignore-preflight-errors Swap &>> /tmp/initout.log
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
echo export KUBECONFIG=/etc/kubernetes/admin.conf | sudo tee -a /root/.bashrc

sudo systemctl enable kubelet

sleep 12
echo "Waiting for 120 Seconds...."

cat /tmp/initout.log | grep -A2 mkdir | /bin/bash
sleep 10
echo "#!/bin/bash" > /vagrant/cltjoincommand.sh
tail -2 /tmp/initout.log >> /vagrant/cltjoincommand.sh