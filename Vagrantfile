# -*- mode: ruby -*-
# vi: set ft=ruby :

# My Github Token: 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
###########################
###   IMAGE VARIABLES   ###
###########################
UBUNTU_VM="xcoo/focal64"
PROVIDER='virtualbox'

#############################
###   NETWORK VARIABLES   ###
#############################
DOCKER_IP="192.168.57.24"


Vagrant.require_version ">=1.8.4"
Vagrant.configure("2") do |config|
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.ssh.insert_key = true
  config.vm.synced_folder ".", "/vagrant"
  #config.vm.box_check_update = false
  #config.vm.box_check_update = false
  #config.vbguest.auto_update = false
  config.vm.provision "shell", inline: <<-SHELL
    echo "Universal Config Complete"
  SHELL

  ##########################
  ###   Docker Engine   #### 
  ##########################
  config.vm.define "docker", autostart:false do |docker|
    docker.vm.box = UBUNTU_VM
    docker.vm.hostname = 'docker'
    docker.vm.network "private_network", ip: DOCKER_IP
    docker.vm.provider PROVIDER do |vbox|
      vbox.memory = "8192"
      vbox.cpus = "4"
    end
    docker.vm.provision "shell", path: "setup-docker.sh"
  end
end