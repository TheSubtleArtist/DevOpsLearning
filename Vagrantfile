# -*- mode: ruby -*-
# vi: set ft=ruby :

#########################
###   BOX VARIABLES   ###
#########################
PROVIDER='virtualbox'
ROCKY_VM="theurbanpenguin/rocky9"
UBUNTU_VM="roboxes/ubuntu2204"

#########################
###   NETWORK VARIABLES   ###
#########################
DB01_IP="192.168.56.5"
MC01_IP="192.168.56.6"
RMQ01_IP="192.168.56.7"
APP01_IP="192.168.56.8"
WEB01_IP="192.168.56.9"



Vagrant.configure("2") do |config|
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.ssh.insert_key = true
  config.vm.synced_folder ".", "/vagrant"
  config.vbguest.auto_update = false
  config.vm.provision "shell", inline: <<-SHELL
    echo "Universal Config Complete"
  SHELL


  ####################
  ###   DATABASE   ###
  ####################
  config.vm.define "db01" do |db01|
    db01.vm.box = ROCKY_VM
    db01.vm.hostname = "db01"
    db01.vm.network "private_network", ip: DB01_IP
    db01.vm.provider PROVIDER do |vbox|
      vbox.memory = "2048"
      vbox.cpus = "2"
      vbox.name = "database"
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
    mc01.vm.provider PROVIDER do |vbox|
      vbox.memory = "2048"
      vbox.cpus = "2"
      vbox.name = "memcache"
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
    rmq01.vm.provider PROVIDER do |vbox|
      vbox.memory = "2048"
      vbox.cpus = "2"
      vbox.name = "rabbitmq"
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
    app01.vm.provider PROVIDER do |vbox|
      vbox.memory = "2048"
      vbox.cpus = "2"
      vbox.name = "tomcat"
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
    web01.vm.provider PROVIDER do |vbox|
      vbox.memory = "2048"
      vbox.cpus = "2"
      vbox.name = "nginx"
    end
    web01.vm.provision "shell", path: "nginx.sh"
  end
end


