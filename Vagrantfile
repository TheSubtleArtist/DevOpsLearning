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
KUBERNETES_IP="192.168.56.13"


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

 #######################
  ###   KUBERNETES   #### 
  #######################
  config.vm.define "kubernetes", autostart:false do |kubernetes|
    kubernetes.vm.box = UBUNTU_VM
    kubernetes.vm.hostname = 'kubernetes'
    kubernetes.vm.network "private_network", ip: KUBE_IP
    kubernetes.vm.provider PROVIDER do |vbox|
      vbox.memory = "8192"
      vbox.cpus = "3"
    end
    kubernetes.vm.provision "shell", path: "setup-kubernetes.sh"
  end
end