# -*- mode: ruby -*-
# vi: set ft=ruby :
# Comment
#########################
###   BOX VARIABLES   ###
#########################
PROVIDER='virtualbox'
ROCKY_VM="theurbanpenguin/rocky9"
UBUNTU_VM="geerlingguy/ubuntu1804"

#########################
###   NETWORK VARIABLES   ###
#########################
DB01_IP="192.168.56.13"
MC01_IP="192.168.56.14"
RMQ01_IP="192.168.56.15"
APP01_IP="192.168.56.16"
WEB01_IP="192.168.56.17"
SRC01_IP="192.168.56.18"



Vagrant.configure("2") do |config|
  config.hostmanager.enabled = true 
  config.hostmanager.manage_host = true
  config.vm.provider PROVIDER
  config.vm.synced_folder ".", "/vagrant"


  ####################
  ###   DATABASE   ###
  ####################
  config.vm.define "db01" do |db01|
    db01.vm.box = ROCKY_VM
    db01.vm.hostname = "db01"
    db01.vm.network "private_network", ip: DB01_IP
    db01.vm.provider PROVIDER do |provider|
      provider.memory = "600"
    end
    #db01.vm.provision "shell", path: "mysql.sh"  
  end
  
  ########################
  ###   MEMCACHE VM   ####
  ######################## 
  # https://www.golinuxcloud.com/install-memcached-rocky-linux-9/
  config.vm.define "mc01" do |mc01|
    mc01.vm.box = ROCKY_VM
    mc01.vm.hostname = "mc01"
    mc01.vm.network "private_network", ip: MC01_IP
    mc01.vm.provider PROVIDER do |provider|
      provider.memory = "600"
    end
    #mc01.vm.provision "shell", path: "memcache.sh"
  end

  ############################
  ###   RABBITMQ SERVER    ###
  ############################
  # https://www.rabbitmq.com/docs/install-rpm
  config.vm.define "rmq01" do |rmq01|
    rmq01.vm.box = ROCKY_VM
	  rmq01.vm.hostname = "rmq01"
    rmq01.vm.network "private_network", ip: RMQ01_IP
    rmq01.vm.provider PROVIDER do |provider|
      provider.memory = "600"
    end
    rmq01.vm.provision "shell", inline: <<-SHELL

    sudo yum install wget epel-release -y

    sudo wget https://github.com/rabbitmq/erlang-rpm/releases/download/v26.2.5.2/erlang-26.2.5.2-1.el7.x86_64.rpm
    sudo wget https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.13.5/rabbitmq-server-3.13.5-1.el8.noarch.rpm


    sudo dnf update -y
    sudo yum install libncurses* -y
    sudo dnf install socat logrotate -y
    sudo rpm -i erlang-26.2.5.2-1.el7.x86_64.rpm
    sudo rpm -i rabbitmq-server-3.13.5-1.el8.noarch.rpm

    systemctl enable --now rabbitmq-server
    systemctl start rabbitmq-server
    firewall-cmd --add-port=5672/tcp --zone=public --permanent
    firewall-cmd --reload

    sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
    sudo rabbitmqctl add_user test test
    sudo rabbitmqctl set_user_tags test administrator
    sudo systemctl restart rabbitmq-server

    SHELL
  end

  #####################
  ###   TOMCAT VM   ###
  #####################
  config.vm.define "app01" do |app01|
    app01.vm.box = UBUNTU_VM
    app01.vm.hostname = "app01"
    app01.vm.network "private_network", ip: APP01_IP
	  app01.vm.provider PROVIDER do |provider|
     provider.memory = "800"
	  end
    app01.vm.provision "shell", inline: <<-SHELL
      sudo apt-get check-update -y
      sudo apt-get install openjdk-8-jdk -y
      wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.91/bin/apache-tomcat-9.0.91.tar.gz
      sudo tar xzvf apache-tomcat-9.0.91.tar.gz
      sudo useradd --home-dir /usr/local/tomcat --shell /sbin/nologin tomcat
      sudo mkdir -p /usr/local/tomcat9
      sudo cp -r apache-tomcat-9.0.91/* /usr/local/tomcat9/
      sudo chown -R tomcat:tomcat /usr/local/tomcat9
      sudo cp /vagrant/tomcat-service.txt /etc/systemd/system/tomcat.service
      sudo chmod 770 /etc/systemd/system/tomcat.service
      sudo systemctl enable tomcat
      sudo systemctl start tomcat 
      sudo systemctl status tocmat



      #cat <<- EOF > tomcat/conf/tomcat-users.xml
      #  <role rolename="tomcat"/>
      #  <role rolename="role1"/>
      #  <user username="tomcat" password="<must-be-changed>" roles="tomcat"/>
      #  <user username="both" password="<must-be-changed>" roles="tomcat,role1"/>
      #  <user username="role1" password="<must-be-changed>" roles="role1"/>
      #EOF
      #sudo apt install tomcat8 tomcat8-admin tomcat8-docs tomcat8-common git -y
    SHELL
  end
  
   ####################
   ###   NGINX VM   ###
   ####################
  config.vm.define "web01" do |web01|
    web01.vm.box = UBUNTU_VM
    web01.vm.hostname = "web01"
	  web01.vm.network "private_network", ip: WEB01_IP
    web01.vm.provider PROVIDER do |provider|
      provider.gui = true
      provider.memory = "800"
    end
    #web01.vm.provision "shell", path: "nginx.sh"
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


