#!/bin/bash

VERSION='1.29.6-1.1'
WORKER=$(hostname)

# Step 1: Unhold Kubeadm and Install Required Version
sudo apt-mark unhold kubeadm
sudo apt-get update -y 
sudo apt-get install -y kubeadm=$VERSION
sudo apt-mark hold kubeadm

# Step 2: Upgrde Kubeadm 
sudo kubeadm upgrade node

# Step 3: Drain the Node 
sudo kubectl drain $WORKER --ignore-daemonsets


# Step 4: Upgrade Kubelet & Kubectl 
sudo apt-mark unhold kubelet kubectl
sudo apt-get update -y
sudo apt-get install -y kubelet kubectl
sudo apt-mark hold kubelet kubectl
sudo systemctl daemon-reload
sudo systemctl restart kubelet

# Step 5: Uncordon worker node
kubectl uncordon $WORKER
