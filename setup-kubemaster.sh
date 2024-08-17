#!/bin/bash

# https://www.digitalocean.com/community/tutorials/how-to-create-a-kubernetes-cluster-using-kubeadm-on-ubuntu-20-04

sudo apt update 
sudo apt-get upgrade -y
sudo apt-get install -y unzip git

# INSTALL ANSIBLE
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible
cd /home/vagrant/kube-cluster


cp /vagrant/hosts .
cp /vagrant/initial.yml .
cp /vagrant/kube-dependencies.yml .
cp /vagrant/control-plane.yml .
cp /vagrant/workers.yml .
cp /vagrant/setup-kube.yml .
pwd 

ansible hosts -m ping -i hosts

ansible-playbook -i hosts setup-kube.yml
