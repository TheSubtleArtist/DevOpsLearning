# -*- mode: ruby -*-
# vi: set ft=ruby :


###########################
###   IMAGE VARIABLES   ###
###########################
UBUNTU_VM="xcoo/focal64"
ROCKY_VM="generic/rocky8"
PROVIDER='virtualbox'

#############################
###   NETWORK VARIABLES   ###
#############################
WEB_KAFE_IP="192.168.56.3"
WORDPRESS_IP="192.168.56.4"


Vagrant.configure("2") do |config|
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.ssh.insert_key = true
  config.vm.synced_folder ".", "/host_share"
  #config.vm.box_check_update = false
  #config.vm.box_check_update = false
  config.vbguest.auto_update = false
  config.vm.provision "shell", inline: <<-SHELL
    echo "Universal Config Complete"
  SHELL

  ################################
  ###   Proect 01a  WebKafe   #### 
  ################################
  config.vm.define "webkafe", autostart:false do |webkafe|
    webkafe.vm.box = ROCKY_VM
    webkafe.vm.hostname = 'webkafe'
    webkafe.vm.network "private_network", ip: WEB_KAFE_IP
    webkafe.vm.provider PROVIDER do |vbox|
      vbox.memory = "512"
      vbox.cpus = "1"
      vbox.name = "webkafe"

    end
    webkafe.vm.provision "shell", path: "setup-webkafe.sh"
  end


  ##################################
  ###   PROJECT 01b WORDPRESS   #### 
  ##################################
  config.vm.define "wordpress", autostart:false do |wordpress|
    wordpress.vm.box = UBUNTU_VM
    wordpress.vm.hostname = 'wordpress'
    wordpress.vm.network "private_network", ip: WORDPRESS_IP
    wordpress.vm.provider PROVIDER do |vbox|
      vbox.memory = "512"
      vbox.cpus = "1"
    end
    wordpress.vm.provision "shell", path: "setup-wordpress.sh"
  end
end