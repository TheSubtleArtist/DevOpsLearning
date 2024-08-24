# -*- mode: ruby -*-
# vi: set ft=ruby :
###########################
###   IMAGE VARIABLES   ###
###########################
UBUNTU_VM='xcoo/focal64'
ROCKY_VM='generic/rocky8'
PROVIDER='virtualbox'

#############################
###   NETWORK VARIABLES   ###
#############################
JENKINS_IP="192.168.56.31"
NEXUS_IP="192.168.56.32"
SONAR_IP="192.168.56.33"
BACKEND_IP="192.168.56.34"
TOMCAT_STAGING_IP="192.168.56.35"
TOMCAT_PRODUCTION_IP="192.168.56.36"

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


  ###################
  ###   JENKINS   ### 
  ###################
  config.vm.define "jenkins", autostart:true do |jenkins|
    jenkins.vm.box = UBUNTU_VM
    jenkins.vm.hostname = 'jenkins'
    jenkins.vm.network "private_network", ip: JENKINS_IP
    jenkins.vm.provider PROVIDER do |vbox|
      vbox.memory = "12288"
      vbox.cpus = "3"
    end
    jenkins.vm.provision "shell", path: "setup-jenkins-ubuntu.sh"
  # Credentials: jenkins:jenkinspassword123
  end
  #################
  ###   NEXUS   ### 
  #################
  config.vm.define "nexus", autostart:true do |nexus|
    nexus.vm.box = UBUNTU_VM
    nexus.vm.hostname = "nexus"
    nexus.vm.network "private_network", ip: NEXUS_IP
    nexus.vm.provider PROVIDER do |vbox|
      vbox.memory = "4096"
      vbox.cpus = "2"
    end
    #nexus.vm.provision "shell", path: "setup-nexus-ubuntu.sh"
    # admin:nexuspassword123
  end
  #####################
  ###   SONARQUBE   ### 
  #####################
  config.vm.define "sonar", autostart:true do |sonar|
    sonar.vm.box = UBUNTU_VM
    sonar.vm.hostname = "sonarqube"
    sonar.vm.network "private_network", ip: SONAR_IP
    sonar.vm.provider "virtualbox" do |vbox|
      vbox.memory = "8192"
      vbox.cpus = "2"
    end
    sonar.vm.provision "shell", path: "setup-sonar-ubuntu.sh"
  end
  #jenkins-sonar-token:7fdc0a885c22cb70bdaed96b7dff063cdb9f6d3f
  #admin:admin
  ###################################
  ###       BACKEND SERVER       #### 
  ###################################
  config.vm.define "backend", autostart:false do |backend|
    backend.vm.box = ROCKY_VM
    backend.vm.hostname = 'backend'
    backend.vm.network "private_network", ip: BACKEND_IP
    backend.vm.provider PROVIDER do |vbox|
      vbox.memory = "4096"
      vbox.cpus = "2"
      vbox.name = "backend-server"
    end
    backend.vm.provision "shell", inline: <<-SHELL
      sudo dnf update -y
    SHELL
    backend.vm.provision "shell", path: "setup-mariadb-rocky.sh"
    backend.vm.provision "shell", path: "setup-memcached-rocky.sh"
    backend.vm.provision "shell", path: "setup-rabbitmq-rocky.sh"
  end

  ###################################
  ###       TOMCAT STAGING       #### 
  ###################################
  config.vm.define "staging", autostart:false do |staging|
    staging.vm.box = UBUNTU_VM
    staging.vm.hostname = 'staging'
    staging.vm.network "private_network", ip: TOMCAT_STAGING_IP
    staging.vm.provider PROVIDER do |vbox|
      vbox.memory = "4096"
      vbox.cpus = "2"
      vbox.name = "tomcat-staging"
    end
    staging.vm.provision "shell", inline: <<-SHELL
      sudo apt update -y
      sudo apt-get upgrade -y
    SHELL
    staging.vm.provision "shell", path: "setup-tomcat-ubuntu.sh"
  end
  
  ###################################
  ###       TOMCAT PRODUCTION     #### 
  ###################################
  config.vm.define "production", autostart:false do |production|
    production.vm.box = UBUNTU_VM
    production.vm.hostname = 'production'
    production.vm.network "private_network", ip: TOMCAT_PRODUCTION_IP
    production.vm.provider PROVIDER do |vbox|
      vbox.memory = "4096"
      vbox.cpus = "2"
      vbox.name = "tomcat-production"
    end
    #production.vm.provision "shell", inline: <<-SHELL
    #  sudo apt update -y
    #  sudo apt-get upgrade -y
    #SHELL
    #production.vm.provision "shell", path: "tomcat-setup-ubuntu.sh"
  end
end