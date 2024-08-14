# -*- mode: ruby -*-
# vi: set ft=ruby :
# Comment
#########################
###   BOX VARIABLES   ###
#########################
PROVIDER='virtualbox'
ROCKY_VM="theurbanpenguin/rocky9"
UBUNTU_VM="roboxes/ubuntu2204"

#########################
###   NETWORK VARIABLES   ###
#########################
DB01_IP="192.168.56.12"
MC01_IP="192.168.56.8"
RMQ01_IP="192.168.56.9"
APP01_IP="192.168.56.10"
WEB01_IP="192.168.56.11"



Vagrant.configure("2") do |config|
  config.hostmanager.enabled = true 
  config.hostmanager.manage_host = true
  config.vm.provider PROVIDER
  config.vm.synced_folder ".", "/vagrant"


  ####################
  ###   DATABASE   ###
  ####################
  config.vm.define "db01" do |db01|
    db01.vm.box = ROCKY_VM
    db01.vm.hostname = "db01"
    db01.vm.network "private_network", ip: DB01_IP
    db01.vm.provider PROVIDER do |provider|
      provider.memory = "600"
    end
    db01.vm.provision "shell", path: "mysql.sh"  
  end
  
  ########################
  ###   MEMCACHE VM   ####
  ######################## 
  # https://www.golinuxcloud.com/install-memcached-rocky-linux-9/
  config.vm.define "mc01" do |mc01|
    mc01.vm.box = ROCKY_VM
    mc01.vm.hostname = "mc01"
    mc01.vm.network "private_network", ip: MC01_IP
    mc01.vm.provider PROVIDER do |provider|
      provider.memory = "600"
    end
    mc01.vm.provision "shell", path: "memcache.sh"
  end

  ############################
  ###   RABBITMQ SERVER    ###
  ############################
  # https://www.rabbitmq.com/docs/install-rpm
  config.vm.define "rmq01" do |rmq01|
    rmq01.vm.box = ROCKY_VM
	  rmq01.vm.hostname = "rmq01"
    rmq01.vm.network "private_network", ip: RMQ01_IP
    rmq01.vm.provider PROVIDER do |provider|
      provider.memory = "600"
    end
    rmq01.vm.provision "shell", path: "rabbitmq.sh"
  end

  #####################
  ###   TOMCAT VM   ###
  #####################
  config.vm.define "app01" do |app01|
    app01.vm.box = ROCKY_VM
    app01.vm.hostname = "app01"
    app01.vm.network "private_network", ip: APP01_IP
	  app01.vm.provider PROVIDER do |provider|
     provider.memory = "800"
	  end
    app01.vm.provision "shell", path: "tomcat.sh" 
  end
  
   ####################
   ###   NGINX VM   ###
   ####################
  config.vm.define "web01" do |web01|
    web01.vm.box = UBUNTU_VM
    web01.vm.hostname = "web01"
	  web01.vm.network "private_network", ip: WEB01_IP
    web01.vm.provider PROVIDER do |provider|
      provider.gui = true
      provider.memory = "800"
    end
    web01.vm.provision "shell", path: "nginx.sh"
  end
end


