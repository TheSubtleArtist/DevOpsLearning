# -*- mode: ruby -*-
# vi: set ft=ruby :
#
Vagrant.configure("2") do |config|
  config.vm.synced_folder ".", "/host_share"
  config.vm.provision "shell", inline: <<-SHELL
      apt-get update -y
      echo "192.168.57.10  master-node" >> /etc/hosts
      echo "192.168.57.11  worker-node01" >> /etc/hosts
      echo "192.168.57.12  worker-node02" >> /etc/hosts
  SHELL

  config.vm.define "master", autostart:true do |master|
    master.vm.box = "bento/ubuntu-22.04"
    master.vm.hostname = "master-node"
    master.vm.network "private_network", ip: "192.168.59.10"
    master.vm.provider "virtualbox" do |vb|
        vb.memory = 4048
        vb.cpus = 2
    end
    master.vm.provision "shell", path: "FirstSetUpAllNodes.sh"
    master.vm.provision "shell", path: "SecondSetUpMasterNode.sh"
  end

  (1..2).each do |i|

  config.vm.define "node0#{i}", autostart:true do |node|
    node.vm.box = "bento/ubuntu-22.04"
    node.vm.hostname = "node0#{i}"
    node.vm.network "private_network", ip: "192.168.57.1#{i}"
    node.vm.provider "virtualbox" do |vb|
        vb.memory = 2048
        vb.cpus = 1
    end
    node.vm.provision "shell", path: "FirstSetUpAllNodes.sh"
  end
end
end
