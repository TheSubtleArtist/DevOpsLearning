# -*- mode: ruby -*-
# vi: set ft=ruby :
###########################
###   IMAGE VARIABLES   ###
###########################
UBUNTU_VM='xcoo/focal64'
PROVIDER='virtualbox'
# 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
#############################
###   NETWORK VARIABLES   ###
#############################
KUBECONTROL_IP="192.168.56.28"
KUBESLAVEONE_IP="192.168.56.29"
KUBESLAVETWO_IP="192.168.56.30"


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
  #############################
  ###   KUBERNETES NODE 1  #### 
  #############################
  config.vm.define "kubeslaveone", autostart:true do |kubeslaveone|
    kubeslaveone.vm.box = UBUNTU_VM
    kubeslaveone.vm.hostname = "kubenodeone"
    kubeslaveone.vm.network "private_network", ip: KUBESLAVEONE_IP
    kubeslaveone.vm.provider PROVIDER do |vbox|
      vbox.name = "kubeslaveone"
      vbox.memory = "4096"
      vbox.cpus = "2"
    end
    kubeslaveone.vm.provision "shell", path: "setup-os-slave.sh"
  end
  #############################
  ###   KUBERNETES NODE 2  #### 
  #############################
  config.vm.define "kubeslavetwo", autostart:true do |kubeslavetwo|
    kubeslavetwo.vm.box = UBUNTU_VM
    kubeslavetwo.vm.hostname = 'kubeslavetwo'
    kubeslavetwo.vm.network "private_network", ip: KUBENODETWO_IP
    kubeslavetwo.vm.provider PROVIDER do |vbox|
      vbox.name = "kubeslavetwo"
      vbox.memory = "4096"
      vbox.cpus = "2"
    end
    kubeslavetwo.vm.provision "shell", path: "setup-os-slave.sh"
  end
  #############################
  ###   KUBERNETES MASTER  #### 
  #############################
  config.vm.define "kubecontrol", autostart:true do |kubecontrol|
    kubecontrol.vm.box = UBUNTU_VM
    kubecontrol.vm.hostname = 'kubecontrol'
    kubecontrol.vm.network "private_network", ip: KUBECONTROL_IP
    kubecontrol.vm.provider PROVIDER do |vbox|
      vbox.name = "kubecontrol"
      vbox.memory = "4096"
      vbox.cpus = "2"
    end
    kubecontrol.vm.provision "shell", path: "os-setup-master.sh"
  end
end