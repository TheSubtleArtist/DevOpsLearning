# -*- mode: ruby -*-
# vi: set ft=ruby :
###########################
###   IMAGE VARIABLES   ###
###########################
UBUNTU_VM='xcoo/focal64'
PROVIDER='virtualbox'

#############################
###   NETWORK VARIABLES   ###
#############################
KUBEMASTER_IP="192.168.56.25"
KUBENODEONE_IP="192.168.56.26"
KUBENODETWO_IP="192.168.56.27"


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

  #############################
  ###   KUBERNETES MASTER  #### 
  #############################
  config.vm.define "kubemaster", autostart:true do |kubemaster|
    kubemaster.vm.box = UBUNTU_VM
    kubemaster.vm.hostname = 'kubemaster'
    kubemaster.vm.network "private_network", ip: KUBEMASTER_IP
    kubemaster.vm.provider PROVIDER do |vbox|
      vbox.name = "kubemaster"
      vbox.memory = "4096"
      vbox.cpus = "2"
    end
    #kubemaster.vm.provision "shell", path: "setup-kubernetes.sh"
    kubemaster.vm.provision "shell", path: "setup-kubemaster.sh"
  end
  #############################
  ###   KUBERNETES NODE 1  #### 
  #############################
  config.vm.define "kubenodeone", autostart:true do |kubenodeone|
    kubenodeone.vm.box = UBUNTU_VM
    kubenodeone.vm.hostname = 'kubenodeone'
    kubenodeone.vm.network "private_network", ip: KUBENODEONE_IP
    kubenodeone.vm.provider PROVIDER do |vbox|
      vbox.name = "kubenodeone"
      vbox.memory = "4096"
      vbox.cpus = "2"
    end
    kubenodeone.vm.provision "shell", path: "setup-kubemnode.sh"
  end
  #############################
  ###   KUBERNETES NODE 2  #### 
  #############################
  config.vm.define "kubenodetwo", autostart:true do |kubenodetwo|
    kubenodetwo.vm.box = UBUNTU_VM
    kubenodetwo.vm.hostname = 'kubenodetwo'
    kubenodetwo.vm.network "private_network", ip: KUBENODETWO_IP
    kubenodetwo.vm.provider PROVIDER do |vbox|
      vbox.name = "kubenodetwo"
      vbox.memory = "4096"
      vbox.cpus = "2"
    end
    kubenodetwo.vm.provision "shell", path: "setup-kubemaster.sh"
  end
end