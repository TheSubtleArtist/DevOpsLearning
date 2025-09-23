# -*- mode: ruby -*-
# vi: set ft=ruby :

###########################
###   IMAGE VARIABLES   ###
###########################
UBUNTU_VM="geerlingguy/ubuntu1804"
ROCKY_VM="generic/rocky8"
PROVIDER='virtualbox'

#############################
###   NETWORK VARIABLES   ###
#############################
JENKINS_IP="192.168.56.21"
NEXUS_IP="192.168.56.22"
SONAR_IP="192.168.56.23"
ROCKY_IP="192.168.56.24"
UBUNTU_IP="192.168.56.25"

Vagrant.configure("2") do |config|
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  #config.ssh.insert_key = true
  config.vm.synced_folder ".", "/host_share"
  #config.vm.box_check_update = false
  #config.vm.box_check_update = false
  #config.vbguest.auto_update = false
  config.vm.provision "shell", inline: <<-SHELL
    echo "Universal Config Complete"
  SHELL
  ############################
  ###   ROCKY EXPERIMENT   ### 
  ############################
  config.vm.define "rocky", autostart:false do |rocky|
    rocky.vm.box = ROCKY_VM
    rocky.vm.hostname = 'rocky'
    rocky.vm.network "private_network", ip: ROCKY_IP
    rocky.vm.provider PROVIDER do |vbox|
      vbox.memory = "4096"
      vbox.cpus = "2"
    end
    #rocky.vm.provision "shell", path: "some.sh"
    rocky.vm.provision "shell", inline: <<-SHELL
      sudo yum update -y
    SHELL
  end  
  #############################
  ###   UBUNTU EXPERIMENT   ### 
  #############################
  config.vm.define "ubuntu", autostart:false do |ubuntu|
    ubuntu.vm.box = UBUNTU_VM
    ubuntu.vm.hostname = 'ubuntu'
    ubuntu.vm.network "private_network", ip: UBUNTU_IP
    ubuntu.vm.provider PROVIDER do |vbox|
      vbox.memory = "8192"
      vbox.cpus = "2"
    end
    #ubuntu.vm.provision "shell", path: "setup.sh"
    ubuntu.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update -y
      sudo apt-get upgrade -y
    SHELL
  # Credentials: jenkinsadmin:jenkinspassword123
  end
  ###################
  ###   JENKINS   ### 
  ###################
  config.vm.define "jenkins", autostart:true do |jenkins|
    jenkins.vm.box = ROCKY_VM
    jenkins.vm.hostname = 'jenkins'
    jenkins.vm.network "private_network", ip: JENKINS_IP
    jenkins.vm.provider PROVIDER do |vbox|
      vbox.memory = "8192"
      vbox.cpus = "2"
    end
    #jenkins.vm.provision "shell", path: "jenkins-setup-ubuntu.sh"
    jenkins.vm.provision "shell", path: "jenkins-setup-rocky.sh"
  # Credentials: jenkinsadmin:jenkinspassword123
  end
  #################
  ###   NEXUS   ### 
  #################
  config.vm.define "nexus", autostart:true do |nexus|
    nexus.vm.box = ROCKY_VM
    nexus.vm.hostname = 'nexus'
    nexus.vm.network "private_network", ip: NEXUS_IP
    nexus.vm.provider PROVIDER do |vbox|
      vbox.memory = "4096"
      vbox.cpus = "2"
    end
    nexus.vm.provision "shell", path: "nexus-setup.sh"
    #admin:nexuspassword123
  end
  
  #####################
  ###   SONARQUBE   ### 
  #####################
  config.vm.define "sonarqube", autostart:true do |sonar|
    sonar.vm.box = UBUNTU_VM
    sonar.vm.hostname = "sonarqube"
    sonar.vm.network "private_network", ip: SONAR_IP
    sonar.vm.provider "virtualbox" do |vbox|
      vbox.memory = "4096"
      vbox.cpus = "2"
    end
    sonar.vm.provision "shell", path: "sonar-setup.sh"
    #sonar.vm.provision "shell", path: "sonar-setup-ubuntu.sh"
  end
end