#!/bin/bash

# https://www.digitalocean.com/community/tutorials/how-to-create-a-kubernetes-cluster-using-kubeadm-on-ubuntu-20-04

sudo apt update 
sudo apt-get upgrade -y
sudo apt-get install -y unzip git

# INSTALL ANSIBLE
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

mkdir -p ~/kube-cluster
cd ~/kube-cluster

cat << HOSTS > ~/kube-cluster/hosts
# Ansible Invnetory File
kubemaster  ansible_host=192.168.56.25 ansible_user=vagrant
kubenodeone ansible_host=192.168.56.26 ansible_user=vagrant
kubenodetwo ansible_host=192.168.56.27 ansible_user=vagrant


[control_plane]
kubemaster

[workers]
kubenodeone
kubenodetwo

[all:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_user=vagrant 
ansible_ssh_private_key_file=~/.ssh/kube_rsa
HOSTS

cat << INITIAL > ~/kube-cluster/initial.yml
---
- hosts: all
  become: yes
  tasks:
    - name: create the 'ubuntu' user
      user: name=ubuntu append=yes state=present createhome=yes shell=/bin/bash

    - name: allow 'ubuntu' to have passwordless sudo
      lineinfile:
        dest: /etc/sudoers
        line: 'ubuntu ALL=(ALL) NOPASSWD: ALL'
        validate: 'visudo -cf %s'

    - name: set up authorized keys for the ubuntu user
      authorized_key: user=ubuntu key="{{item}}"
      with_file:
        - ~/.ssh/ubuntu_rsa.pub
INITIAL

ansible-playbook -i hosts.yml ~/kube-cluster/kube-dependencies.yml

cat << DEPENDS > ~/kube-cluster/initial.yml
---
- hosts: all
  become: yes
  tasks:
   - name: create Docker config directory
     file: path=/etc/docker state=directory

   - name: changing Docker to systemd driver
     copy:
      dest: "/etc/docker/daemon.json"
      content: |
        {
        "exec-opts": ["native.cgroupdriver=systemd"]
        }

   - name: install Docker
     apt:
       name: docker.io
       state: present
       update_cache: true

   - name: install APT Transport HTTPS
     apt:
       name: apt-transport-https
       state: present

   - name: add Kubernetes apt-key
     apt_key:
       url: https://packages.cloud.google.com/apt/doc/apt-key.gpg
       state: present

   - name: add Kubernetes' APT repository
     apt_repository:
      repo: deb http://apt.kubernetes.io/ kubernetes-xenial main
      state: present
      filename: 'kubernetes'

   - name: install kubelet
     apt:
       name: kubelet=1.22.4-00
       state: present
       update_cache: true

   - name: install kubeadm
     apt:
       name: kubeadm=1.22.4-00
       state: present

- hosts: control_plane
  become: yes
  tasks:
   - name: install kubectl
     apt:
       name: kubectl=1.22.4-00
       state: present
       force: yes

DEPENDS

ansible-playbook -i hosts.yml ~/kube-cluster/kube-dependencies.yml

cat << CONTROL > ~/kube-cluster/initial.yml

---
- hosts: control_plane
  become: yes
  tasks:
    - name: initialize the cluster
      shell: kubeadm init --pod-network-cidr=10.244.0.0/16 >> cluster_initialized.txt
      args:
        chdir: $HOME
        creates: cluster_initialized.txt

    - name: create .kube directory
      become: yes
      become_user: ubuntu
      file:
        path: $HOME/.kube
        state: directory
        mode: 0755

    - name: copy admin.conf to user's kube config
      copy:
        src: /etc/kubernetes/admin.conf
        dest: /home/ubuntu/.kube/config
        remote_src: yes
        owner: ubuntu

    - name: install Pod network
      become: yes
      become_user: ubuntu
      shell: kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml >> pod_network_setup.txt
      args:
        chdir: $HOME
        creates: pod_network_setup.txt
CONTROL

ansible-playbook -i hosts.yml ~/kube-cluster/control-plane.yml

kubectl get nodes

cat << WORKERS > ~/kube-cluster/workers.yml
---
- hosts: control_plane
  become: yes
  gather_facts: false
  tasks:
    - name: get join command
      shell: kubeadm token create --print-join-command
      register: join_command_raw

    - name: set join command
      set_fact:
        join_command: "{{ join_command_raw.stdout_lines[0] }}"


- hosts: workers
  become: yes
  tasks:
    - name: join cluster
      shell: "{{ hostvars['control1'].join_command }} >> node_joined.txt"
      args:
        chdir: $HOME
        creates: node_joined.txt
WORKERS

kubectl create deployment nginx --image=nginx

kubectl expose deploy nginx --port 80 --target-port 80 --type NodePort

kubectl get services
