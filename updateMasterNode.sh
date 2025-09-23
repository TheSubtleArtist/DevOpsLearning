#!/bin/bash

VERSION="1.29.6"
CONTROL_PLANE="master-node" # name of the control plan

# Step 1: Check the existing Kubeadm version
kubeadm version -o json

# Step 2: unhold kubeadm and Install the latest version
sudo apt-mark unhold kubeadm 
sudo apt-cache madison kubeadm | tac
sudo apt-get update -y
sudo apt-get install -y kubeadm=$VERSION
sudo apt-mark hold kubeadm

# Step 3: Decide on the upgrade version
sudo kubeadm upgrade plan

# Step 4: Apply Kubeadm upgrade
sudo kubeadm upgrade apply v$VERSION -y

# Step 5: Drain the Node to evict all workloads.
sudo kubectl drain $CONTROL_PLANE --ignore-daemonsets

# Step 6: Upgrade Kubelet and Kubectl.
sudo apt-mark unhold kubelet kubectl
sudo apt-get update -y 
sudo apt-get install -y kubelet kubectl
sudo apt-mark hold kubelet kubectl
sudo systemctl daemon-reload
sudo systemctl restart kubelet

# Step 7: Uncordon the Node and Verify the Node Status
sudo kubectl uncordon $CONTROL_PLANE
sudo kubectl get nodes