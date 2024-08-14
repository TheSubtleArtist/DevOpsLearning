# -*- mode: ruby -*-
# vi: set ft=ruby :
# Comment
#########################
###   BOX VARIABLES   ###
#########################
PROVIDER='virtualbox'
ROCKY_VM="theurbanpenguin/rocky9"
UBUNTU_VM="geerlingguy/ubuntu1804"

#############################
###   NETWORK VARIABLES   ###
#############################
SRC01_IP="192.168.56.19"
SRC02_IP="192.168.56.20"



Vagrant.configure("2") do |config|
  config.hostmanager.enabled = true 
  config.hostmanager.manage_host = true
  config.vm.provider PROVIDER
  config.vm.synced_folder ".", "/vagrant"
  
   ######################################
   ###   ALTERNATE SRC CODE BUILDER   ###
   ######################################
  config.vm.define "src02" do |src02|
    src02.vm.box = UBUNTU_VM
    src02.vm.hostname = "src02"
	  src02.vm.network "private_network", ip: SRC02_IP
    src02.vm.provider PROVIDER do |provider|
      provider.gui = true
      provider.memory = "800"
    end
    src02.vm.provision "shell", inline: <<-SHELL
    echo "HELLO WORLD"
    sudo apt-get update -y
    sudo apt-get install openjdk-8-jdk openjdk-8-jre maven git mysql-client unzip -y
    wget "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -O "awscliv2.zip"
    unzip awscliv2.zip > /dev/null
    sudo ./aws/install
    git clone https://github.com/devopshydclub/vprofile-project.git
    cd /home/vagrant/vprofile-project
    git checkout local-setup
    mvn install
    SHELL
  end
  ################################
  ##   SOURCE CODE BUILD VM   ####
  ################################ 
  config.vm.define "src01" do |src01|
    src01.vm.box = ROCKY_VM
    src01.vm.hostname = "src01"
    src01.vm.network "private_network", ip: SRC01_IP
    src01.vm.provider PROVIDER do |provider|
      provider.memory = "600"
    end   
    src01.vm.provision "shell", inline: <<-SHELL
      echo "Hello World"
      sudo yum install epel-release -y
      sudo yum install java-1.8.0-openjdk -y
      sudo yum install maven -y
      export MAVEN_OPTS="-Xmx512m"
      sudo yum install git -y
      wget "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -O "awscliv2.zip"
      unzip awscliv2.zip > /dev/null
      sudo ./aws/install
      sudo yum update -y
      git clone https://github.com/devopshydclub/vprofile-project.git
      cd /home/vagrant/vprofile-project
      git config --global --add safe.directory /home/vagrant/vprofile-project
      git checkout local-setup
      mvn install
      # perform AWS CONFIGURE and add the S3 bucket key
      aws s3 mb s3://04proj-artifact-storage
      # copy the artifact to the bucket
      aws s3 cp /home/vagrant/vprofile-project/target/vprofile-v2.war




      #git config --global --add safe.directory /home/vagrant/vprofile-project
      #sudo git checkout local-setup
      #sudo cp /vagrant/application.properties /home/vagrant/vprofile-project/src/main/resources/application.properties




      #cat <<- SRC > HelloWorld.txt
      #  echo "Hello World!"
      #SRC
      #cat HelloWorld.txt
    SHELL
  end
end


