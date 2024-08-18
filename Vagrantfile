# -*- mode: ruby -*-
# vi: set ft=ruby :

###########################
###   IMAGE VARIABLES   ###
###########################
UBUNTU_VM="xcoo/focal64"
PROVIDER='virtualbox'

#############################
###   NETWORK VARIABLES   ###
#############################
TERRAFORM_IP="192.168.57.31"


Vagrant.require_version ">=1.8.4"
Vagrant.configure("2") do |config|
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.ssh.insert_key = true
  config.vm.synced_folder ".", "/vagrant"
  #config.vm.box_check_update = false
  #config.vm.box_check_update = false
  config.vbguest.auto_update = false
  config.vm.provision "shell", inline: <<-SHELL
    echo "Universal Config Complete"
  SHELL

  ##########################
  ###   Docker Engine   #### 
  ##########################
  config.vm.define "terraform", autostart:false do |terraform|
    terraform.vm.box = UBUNTU_VM
    terraform.vm.hostname = 'terraform'
    terraform.vm.network "private_network", ip: DOCKER_IP
    terraform.vm.provider PROVIDER do |vbox|
      vbox.memory = "8192"
      vbox.cpus = "4"
      vbox.name = "terraform"
    end
    terraform.vm.provision "shell", path: "setup-os.sh"
    terraform.vm.provision "shell", path: "setup-terraform.sh"
    terraform.vm.provision "shell", path: "setup-awscli.sh"
  end
end