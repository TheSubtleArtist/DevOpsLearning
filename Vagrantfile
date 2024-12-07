# -*- mode: ruby -*-
# vi: set ft=ruby :

###########################
###   IMAGE VARIABLES   ###
###########################
UBUNTU_VM="xcoo/focal64"
ROCKY_VM="generic/rocky8"
CENTOS_VM="generic/centos7"
WINDOWS_VM="mwrock/Windows2016"
RHEL_VM="roboxes-x64/rhel9"
PROVIDER='virtualbox'
PROJECT06_UBUNTU="xcoo/bionic64"

#############################
###   NETWORK VARIABLES   ###
#############################
UBUNTU_IP="192.168.100.2"
ROCKY_IP="192.168.100.3"
CENTOS_IP="192.168.100.4"
WEB_KAFE_IP="192.168.100.5"
WORDPRESS_IP="192.168.100.6"
DATABASE_IP="192.168.56.7"
MEMCACHE_IP="192.168.56.8"
RABBITMQ_IP="192.168.56.9"
TOMCAT_IP="192.168.56.10"
NGINX_IP="192.168.56.11"
JENKINS_IP="192.168.56.12"
JENKINS_NODE_1_IP="192.168.56.13"
JENKINS_NODE_2_IP="192.168.56.14"
NEXUS_IP="192.168.56.15"
SONAR_IP="192.168.56.16"
SELENIUM_IP="192.168.56.17"
TOMCAT_STAGING_IP="192.168.56.18"
TOMCAT_PRODUCTION_IP="192.168.56.19"
ANSIBLE_IP="192.168.56.22"
WEB02_IP="192.168.56.23"
WEB03_IP="192.168.56.24"
DBS02_IP="192.168.56.25"
WEB04_IP="192.168.56.26"
WEB05_IP="192.168.56.27"
BACKEND_IP="192.168.56.28"
DOCKER_IP="192.168.57.2"

Vagrant.require_version ">=1.8.4"
Vagrant.configure("2") do |config|
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.ssh.insert_key = true
  config.vm.synced_folder ".", "/host_share"
  #config.vm.box_check_update = false
  #config.vm.box_check_update = false
  #config.vbguest.auto_update = false
  config.vm.provision "shell", inline: <<-SHELL
    echo "Universal Config Complete"
  SHELL

  ####################################
  ###       00 UBUNTU TEST        #### 
  ####################################
  config.vm.define "ubuntu", autostart:false do |ubuntu|
    ubuntu.vm.box = UBUNTU_VM
    ubuntu.vm.hostname = 'ubuntuTest'
    ubuntu.vm.network "private_network", ip: UBUNTU_IP
    ubuntu.vm.provider PROVIDER do |vbox|
      vbox.memory = "2048"
      vbox.cpus = "1"
    end
    ubuntu.vm.provision "shell", inline: <<-SHELL
      sudo apt update -y
      sudo apt-get upgrade -y
    SHELL
  end

  ###################################
  ###      00  ROCKY TEST        #### 
  ###################################
  config.vm.define "rocky", autostart:false do |rocky|
    rocky.vm.box = ROCKY_VM
    rocky.vm.hostname = 'rockyTest'
    rocky.vm.network "private_network", ip: ROCKY_IP
    rocky.vm.provider PROVIDER do |vbox|
      vbox.memory = "2048"
      vbox.cpus = "1"
    end
  end

  ###################################
  ###    00   CENTOS TEST        #### 
  ###################################
  config.vm.define "centos", autostart:false do |centos|
    centos.vm.box = CENTOS_VM
    centos.vm.hostname = 'centosTest'
    centos.vm.network "private_network", ip: CENTOS_IP
    centos.vm.provider PROVIDER do |vbox|
      vbox.memory = "2048"
      vbox.cpus = "1"
    end
    centos.vm.provision "shell", inline: <<-SHELL
      echo "Universal Config Complete"
      sudo yum update -y
    SHELL
  end


  ################################
  ###   Proect 01a  WebKafe   #### 
  ################################
  config.vm.define "webkafe", autostart:false do |webkafe|
    webkafe.vm.box = CENTOS_VM
    webkafe.vm.hostname = 'webkafe'
    webkafe.vm.network "private_network", ip: WEB_KAFE_IP
    webkafe.vm.provider PROVIDER do |vbox|
      vbox.memory = "512"
      vbox.cpus = "1"
    end
    webkafe.vm.provision "shell", inline: <<-SHELL
      yum update -y
      yum install httpd wget unzip -y
      systemctl start httpd
      systemctl enable httpd
      cd /tmp
      wget https://www.tooplate.com/zip-templates/2137_barista_cafe.zip
      unzip -o 2137_barista_cafe.zip
      mkdir /var/www/html/
      cp -r 2137_barista_cafe/* /var/www/html/
      systemctl restart httpd
    SHELL
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
    wordpress.vm.provision "shell", inline: <<-SHELL
    sudo apt update -y
    # INSTALL DEPENDENCIES
    sudo apt install -y apache2 \
                    ghostscript \
                    libapache2-mod-php \
                    mysql-server \
                    php \
                    php-bcmath \
                    php-curl \
                    php-imagick \
                    php-intl \
                    php-json \
                    php-mbstring \
                    php-mysql \
                    php-xml \
                    php-zip
      # INSTALL WORDPRESS
      sudo mkdir -p /srv/www
      sudo chown www-data:www-data /srv/www
      curl https://wordpress.org/latest.tar.gz | sudo -u www-data tar zx -C /srv/www

      # CONFIGURE APACHE FOR WORDPRESS
      sudo cp /host_share/wordpress.conf /etc/apache2/sites-available/wordpress.conf
      sudo chmod 660 /etc/apache2/sites-available/wordpress.conf
      sudo a2ensite wordpress
      sudo a2enmod rewrite
      sudo a2dissite 000-default
      sudo systemctl reload apache2

      # CONFIGURE MYSQL
      sudo mysql -u root -e 'DROP USER IF EXISTS "mydatabaseadmin"@"localhost";'
      sudo mysql -u root -e 'DROP DATABASE IF EXISTS wordpressDB;'
      sudo mysql -u root -e 'CREATE DATABASE mywordpressdb;'
      sudo mysql -u root -e 'CREATE USER "mydatabaseadmin"@"localhost" IDENTIFIED WITH mysql_native_password BY "mydatabasepassword123";'
      sudo mysql -u root -e 'GRANT ALL PRIVILEGES ON mywordpressdb.* TO "mydatabaseadmin"@"localhost";'
      sudo mysql -u root -e 'FLUSH PRIVILEGES;'
      sudo systemctl start mysql
      sudo systemctl enable mysql

      # CONNECT WORDPRESS TO MYSQL
      sudo -u www-data cp /srv/www/wordpress/wp-config-sample.php /srv/www/wordpress/wp-config.php
      sudo -u www-data sed -i 's/database_name_here/mywordpressdb/' /srv/www/wordpress/wp-config.php
      sudo -u www-data sed -i 's/username_here/mydatabaseadmin/' /srv/www/wordpress/wp-config.php
      sudo -u www-data sed -i 's/password_here/mydatabasepassword123/' /srv/www/wordpress/wp-config.php

      # Still need to figure out how to get his into the wp-config file
      WORDPRESS_KEYS="$(curl 'https://api.wordpress.org/secret-key/1.1/salt/')"

      #sudo cp /host_share/config-localhost.php /etc/wordpress/config-192.168.56.14.php
      sudo apt upgrade -y
      sudo apt autoclean -y
    SHELL
  end
  ######################################
  ###   PROJECT 02 DATABASE SERVER   ### 
  ######################################
  config.vm.define "database", autostart:false do |dbs01|
    dbs01.vm.box = CENTOS_VM
    dbs01.vm.hostname = 'db01'
    dbs01.vm.network "private_network", ip: DATABASE_IP
    dbs01.vm.provider PROVIDER do |vbox|
      vbox.memory = "512"
      vbox.cpus = "1"
    end
    dbs01.vm.provision "shell", inline: <<-SHELL
      sudo yum update -y
      DATABASE_PASS='admin123'
      sudo yum install git mariadb-server -y
      sudo systemctl start mariadb.service
      sudo systemctl enable mariadb.service
      sudo systemctl status mariadb.service
      sudo mysqladmin -u root password "$DATABASE_PASS"
      sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
      sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User=''"
      sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
      sudo mysql -u root -p"$DATABASE_PASS" -e "create database accounts"
      sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'app01' identified by 'admin123'"
      sudo git clone https://github.com/devopshydclub/vprofile-project.git
      sudo mysql -u root -p"$DATABASE_PASS" accounts < vprofile-project/src/main/resources/db_backup.sql
      sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"
      sudo systemctl start firewalld
      sudo systemctl enable firewalld
      sudo firewall-cmd --get-active-zones
      sudo firewall-cmd --add-port=3306/tcp --permanent
      sudo firewall-cmd --reload
    SHELL
  end

  ######################################
  ###   PROJECT 02 MEMCACHE SERVER   ### 
  ######################################
  config.vm.define "memcache", autostart:false do |memcache|
    memcache.vm.box = CENTOS_VM
    memcache.vm.hostname = 'mc01'
    memcache.vm.network "private_network", ip: MEMCACHE_IP
    memcache.vm.provider PROVIDER do |vbox|
      vbox.memory = "512"
      vbox.cpus = "1"
    end
    memcache.vm.provision "shell", inline: <<-SHELL
      sudo yum update -y
      sudo yum install memcached -y
      sudo systemctl start memcached
      sudo systemctl enable memcached
      sudo systemctl status memcached
      sudo memcached -p 11211 -U 11111 -u memcached -d
      sudo systemctl start firewalld
      sudo systemctl enable firewalld
      sudo firewall-cmd --add-port=11211/tcp --permanent
      sudo firewall-cmd --reload

    SHELL
  end
  ######################################
  ###   PROJECT 02 RABBITMQ SERVER   ### 
  ######################################
  config.vm.define "rabbitmq", autostart:false do |rabbitmq|
    rabbitmq.vm.box = CENTOS_VM
    rabbitmq.vm.hostname = 'rmq01'
    rabbitmq.vm.network "private_network", ip: RABBITMQ_IP
    rabbitmq.vm.provider PROVIDER do |vbox|
      vbox.memory = "512"
      vbox.cpus = "1"
    end
    rabbitmq.vm.provision "shell", inline: <<-SHELL
      sudo yum update -y
      sudo yum install wget -y
      cd /tmp
      wget http://packages.erlang-solutions.com/erlang-solutions-2.0-1.noarch.rpm
      sudo rpm -Uvh erlang-solutions-2.0-1.noarch.rpm
      sudo yum -y install erlang socat
      curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash
      sudo yum install rabbitmq-server -y
      sudo systemctl start rabbitmq-server
      sudo systemctl enable rabbitmq-server
      sudo systemctl status rabbitmq-server
      sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
      sudo rabbitmqctl add_user test test
      sudo rabbitmqctl set_user_tags test administrator
      sudo systemctl restart rabbitmq-server
      sudo systemctl start firewalld
      sudo systemctl enable firewalld
      sudo firewall-cmd --add-port=5671/tcp --permanent
      sudo firewall-cmd --add-port=5672/tcp --permanent
      sudo firewall-cmd --reload
      sudo yum upgrade -y
    SHELL
  end
  ####################################
  ###   PROJECT 02 TOMCAT SERVER   ### 
  ####################################
  config.vm.define "tomcat", autostart:false do |tomcat01|
    tomcat01.vm.box = CENTOS_VM
    tomcat01.vm.hostname = 'app01'
    tomcat01.vm.network "private_network", ip: TOMCAT_IP
    tomcat01.vm.provider PROVIDER do |vbox|
      vbox.memory = "1024"
      vbox.cpus = "1"
    end
    tomcat01.vm.provision "shell", inline: <<-SHELL
      echo "Build Tomcat Server"
      sudo yum update -y
      sudo yum install epel-release -y
      sudo yum install java-1.8.0-openjdk -y # vprofile-project dependency
      sudo yum install git maven wget -y
      cd /tmp
      wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.37/bin/apache-tomcat-8.5.37.tar.gz
      sudo tar xzvf apache-tomcat-8.5.37.tar.gz
      sudo useradd --home-dir /usr/local/tomcat8 --shell /sbin/nologin tomcat
      sudo cp -r apache-tomcat-8.5.37/* /usr/local/tomcat8/
      sudo chown -R tomcat:tomcat /usr/local/tomcat8/
      sudo cp /host_share/tomcat-service.txt /etc/systemd/system/tomcat.service
      sudo yum upgrade -y

      echo "Build and Deploy Vprofile Artifact"
      sudo git clone https://github.com/devopshydclub/vprofile-project.git
      cd vprofile-project/
      sudo git checkout local-setup
      sudo cp src/main/resources/application.properties /host_folder/
      sudo mvn install

      sudo systemctl stop tomcat
      sudo rm -rf /usr/local/tomcat8/webapps/ROOT
      sudo cp target/vprofile-v2.war /usr/local/tomcat8/webapps/ROOT.war
      sudo systemctl daemon-reload
      sudo systemctl start tomcat
      sudo systemctl status tomcat
      sudo firewall-cmd --add-port=8080/tcp --permanent
      sudo firewall-cmd --reload
    SHELL
  end
  ##################################
  ###  PROJECT 02 NGINX SERVER   ### 
  ##################################
  config.vm.define "nginx", autostart:false do |nginx|
    nginx.vm.box = UBUNTU_VM
    nginx.vm.hostname = 'web01'
    nginx.vm.network "private_network", ip: NGINX_IP
    nginx.vm.provider PROVIDER do |vbox|
      vbox.memory = "1024"
      vbox.cpus = "1"
    end
    nginx.vm.provision "shell", inline: <<-SHELL
     sudo apt update -y
     sudo apt-get upgrade -y

     sudo apt-get install nginx -y
     sudo cp /host_share/nginx-settings.txt /etc/nginx/sites-available/vproapp
     #sudo chmod 660 /etc/nginx/sites-available/vproapp
     sudo rm -rf /etc/nginx/sites-enabled/default
     sudo ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp
     sudo systemctl start nginx
     sudo systemctl enable nginx
     sudo systemctl status nginx
    SHELL
  end
  ################################
  ### PROJECT 03/06 JENKINS   #### 
  ################################
  config.vm.define "jenkins", autostart:false do |jenkins|
    jenkins.vm.box = UBUNTU_VM
    jenkins.vm.hostname = 'jenkins'
    jenkins.vm.network "private_network", ip: JENKINS_IP
    jenkins.vm.provider PROVIDER do |vbox|
      vbox.memory = "8192"
      vbox.cpus = "3"
    end
    jenkins.vm.provision "shell", inline: <<-SHELL
    echo "Jenkins"
    echo "Update"
    sudo apt-get update -y >/dev/null
    echo "Install Dependencies"
    sudo apt-get install fontconfig openjdk-11-jdk >/dev/null
    sudo apt-get install git maven -y >/dev/null
    echo "Keyrings"
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
      https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key 
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
      https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
      /etc/apt/sources.list.d/jenkins.list > /dev/null
    echo "Install Jenkins"
    sudo apt-get install jenkins -y >/dev/null
    sudo apt install software-properties-common >/dev/null
    # Install Ansible
    echo "Install Ansible"
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt update -y >/dev/null
    sudo apt-get install ansible -y
    echo "Update"
    sudo apt-get upgrade -y >/dev/null
    echo "y" | sudo ufw enable
    sudo ufw allow 8080/tcp
    sudo ufw allow ssh
    sudo ufw reload
  SHELL
  end
  #########################################
  ###   PROJECT 04/06 JENKINS NODE 01   ### 
  #########################################
  config.vm.define "jenkinsnode1", autostart:false do |jenkinsnode1|
    jenkinsnode1.vm.box = CENTOS_VM
    jenkinsnode1.vm.hostname = 'jenkinsnode1'
    jenkinsnode1.vm.network "private_network", ip: JENKINS_NODE_1_IP
    jenkinsnode1.vm.provider PROVIDER do |vbox|
      vbox.memory = "4096"
      vbox.cpus = "2"
    end
    jenkinsnode1.vm.provision "shell", inline: <<-SHELL
      yum update -y
    SHELL
  end
  #########################################
  ###   PROJECT 04/06 JENKINS NODE 02   ### 
  #########################################
  config.vm.define "jenkinsnode2", autostart:false do |jenkinsnode2|
    jenkinsnode2.vm.box = UBUNTU_VM
    jenkinsnode2.vm.hostname = 'jenkinsnode2'
    jenkinsnode2.vm.network "private_network", ip: JENKINS_NODE_2_IP
    jenkinsnode2.vm.provider PROVIDER do |vbox|
      vbox.memory = "8192"
      vbox.cpus = "3"
    end
    jenkinsnode2.vm.provision "shell", inline: <<-SHELL
      sudo apt update -y
      #sudo apt-get upgrade -y
      sudo apt-get install openjdk-8-jre -y
      sudo useradd devops -m
      echo devops:mydevopspassword123 | sudo chpasswd
      sudo mkdir -p /opt/jenkins-node
      sudo chown -R devops:devops /opt/jenkins-node
      sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
      sudo systemctl restart ssh
      echo 'y' | sudo ufw enable
      sudo ufw allow 22
    SHELL
  end
  ###############################
  ###   PROJECT 03/06 NEXUS   ### 
  ###############################
  config.vm.define "nexus", autostart:false do |nexus|
    nexus.vm.box = UBUNTU_VM
    nexus.vm.hostname = 'nexus'
    nexus.vm.network "private_network", ip: NEXUS_IP
    nexus.vm.provider PROVIDER do |vbox|
      vbox.memory = "4096"
      vbox.cpus = "1"
    end
    nexus.vm.provision "shell", inline: <<-SHELL
      echo "Nexus"
      NEXUSURL="https://download.sonatype.com/nexus/3/latest-unix.tar.gz"
      sudo apt-get update -y
      sudo apt-get upgrade -y
      sudo apt-get install wget openjdk-8-jre -y
      sudo mkdir -p /opt/nexus
      sudo wget $NEXUSURL -O nexus.tar.gz
      sudo tar -xzvf nexus.tar.gz
      sudo mv nexus-3*/ nexus3
      sudo rm -f nexus.tar.gz
      sudo mv * /opt/nexus
      sudo adduser --system --no-create-home nexus
      sudo chown -R nexus: /opt/nexus
      sudo sed -i 's/#run_as_user=""/run_as_user="nexus"/g' /opt/nexus/nexus3/bin/nexus.rc
      sudo cp -f /host_share/nexus.vmoptions /opt/nexus/nexus3/bin/nexus.vmoptions
      sudo cp -f /host_share/nexus.service /etc/systemd/system/nexus.service
      sudo chmod 440 /etc/systemd/system/nexus.service
      sudo systemctl enable nexus
      sudo systemctl start nexus
      echo 'y' | sudo ufw enable
      sudo ufw allow 8081
      sudo ufw reload
      sudo ufw show added
      sudo systemctl status nexus
    SHELL
  end
  ############################################
  ###   PROJECT 03 TOMCAT STAGING SERVER   ### 
  ############################################
  config.vm.define "tomcat2", autostart:false do |tomcat2|
    tomcat2.vm.box = CENTOS_VM
    tomcat2.vm.hostname = 'tomcat-staging03'
    tomcat2.vm.network "private_network", ip: TOMCAT_STAGING_IP
    tomcat2.vm.provider PROVIDER do |vbox|
      vbox.memory = "2048"
      vbox.cpus = "1"
    end
    tomcat2.vm.provision "shell", inline: <<-SHELL
      echo "Build Tomcat Server"
      sudo yum update -y
      sudo yum install epel-release -y
      sudo yum install java-1.8.0-openjdk -y # vprofile-project dependency
      sudo yum install wget -y
      cd /tmp
      wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.37/bin/apache-tomcat-8.5.37.tar.gz
      sudo tar xzvf apache-tomcat-8.5.37.tar.gz
      sudo useradd --home-dir /usr/local/tomcat8 --shell /sbin/nologin tomcat
      sudo cp -r apache-tomcat-8.5.37/* /usr/local/tomcat8/
      sudo chown -R tomcat:tomcat /usr/local/tomcat8/
      sudo cp /host_share/tomcat-service.txt /etc/systemd/system/tomcat.service
      sudo systemctl daemon-reload
      sudo systemctl start tomcat
      sudo systemctl enable tomcat
      sudo cp /host_share/tomcat-context.xml /usr/local/tomcat8/webapps/manager/META-INF/context.xml
      sudo cp /host_share/tomcat-users.xml /usr/local/tomcat8/conf/tomcat-users.xml
      sudo yum upgrade -y
      sudo systemctl restart tomcat
      sudo systemctl status tomcat
      sudo firewall-cmd --add-port=8080/tcp --permanent
      sudo firewall-cmd --reload
    SHELL
  end
  ###############################################
  ###   PROJECT 03 TOMCAT PRODUCTION SERVER   ### 
  ###############################################
  config.vm.define "tomcat3", autostart:false do |tomcat3|
    tomcat3.vm.box = CENTOS_VM
    tomcat3.vm.hostname = 'tomcat-production03'
    tomcat3.vm.network "private_network", ip: TOMCAT_PRODUCTION_IP
    tomcat3.vm.provider PROVIDER do |vbox|
      vbox.memory = "2048"
      vbox.cpus = "1"
    end
    tomcat3.vm.provision "shell", inline: <<-SHELL
      echo "Build Tomcat Server"
      sudo yum update -y
      sudo yum install epel-release -y
      sudo yum install java-1.8.0-openjdk -y # vprofile-project dependency
      sudo yum install wget -y
      cd /tmp
      wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.37/bin/apache-tomcat-8.5.37.tar.gz
      sudo tar xzvf apache-tomcat-8.5.37.tar.gz
      sudo useradd --home-dir /usr/local/tomcat8 --shell /sbin/nologin tomcat
      sudo cp -r apache-tomcat-8.5.37/* /usr/local/tomcat8/
      sudo chown -R tomcat:tomcat /usr/local/tomcat8/
      sudo cp /host_share/tomcat-service.txt /etc/systemd/system/tomcat.service
      sudo systemctl daemon-reload
      sudo systemctl start tomcat
      sudo cp /host_share/tomcat-context.xml /usr/local/tomcat8/webapps/manager/META-INF/context.xml
      sudo cp /host_share/tomcat-users.xml /usr/local/tomcat8/conf/tomcat-users.xml
      sudo yum upgrade -y
      sudo systemctl restart tomcat
      sudo systemctl status tomcat
      sudo firewall-cmd --add-port=8080/tcp --permanent
      sudo firewall-cmd --reload
    SHELL
  end
  ###################################
  ###   PROJECT 04/06 SONARQUBE   ### 
  ###################################
  config.vm.define "sonar", autostart:false do |sonar|
    sonar.vm.box = UBUNTU_VM
    sonar.vm.hostname = "sonarqube"
    sonar.vm.network "private_network", ip: SONAR_IP
    sonar.vm.provider "virtualbox" do |vbox|
      vbox.memory = "2048"
      vbox.cpus = "1"
    end
    #sonar.vm.provision "shell", path: "sonar-setup.sh"
    sonar.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update -y
      EXPORT DEBIAN_FRONTEND=noninteractive # Reference: https://serverfault.com/questions/500764/dpkg-reconfigure-unable-to-re-open-stdin-no-file-or-directory
      sudo apt-get install -y unzip
      sudo apt-get install -y openjdk-11-jdk
      sudo cp /host_share/sonar-sysctl.conf /etc/sysctl.conf

      # Install Postgresql
      wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
      sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
      sudo apt install postgresql postgresql-contrib -y
      sudo systemctl enable postgresql.service
      sudo systemctl start  postgresql.service
      echo postgres:admin123 | sudo chpasswd
      runuser -l postgres -c "createuser sonar"
      sudo -i -u postgres psql -c "ALTER USER sonar WITH ENCRYPTED PASSWORD 'admin123';"
      sudo -i -u postgres psql -c "CREATE DATABASE sonarqube OWNER sonar;"
      sudo -i -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar;"
      sudo systemctl restart  postgresql

      # Install SonarQube
      sudo mkdir -p /sonarqube
      cd /sonarqube/
      sudo curl -O https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.3.0.34182.zip
      sudo apt-get install zip -y
      sudo unzip -o sonarqube-8.3.0.34182.zip -d /opt/
      sudo mv /opt/sonarqube-8.3.0.34182/ /opt/sonarqube
      sudo groupadd sonar
      sudo useradd -c "SonarQube - User" -d /opt/sonarqube/ -g sonar sonar
      sudo chown sonar:sonar /opt/sonarqube/ -R
      sudo cp /opt/sonarqube/conf/sonar.properties /root/sonar.properties_backup
      sudo cp /host_share/sonar.properties /opt/sonarqube/conf/sonar.properties
      sudo cp /host_share/sonarqube.service /etc/systemd/system/sonarqube.service
      sudo systemctl daemon-reload
      sudo systemctl enable sonarqube.service
      sudo systemctl start sonarqube.service
      echo 'y' | sudo ufw enable
      sudo ufw allow 9000
      sudo ufw reload
    SHELL

  end
  #########################################
  ###   PROJECT 05 ANSIBLE CONTROLLER   ###
  #########################################
  config.vm.define "ansible", autostart:false do |ansible|
    ansible.vm.box = UBUNTU_VM
    ansible.vm.hostname = 'ansible'
    ansible.vm.network "private_network", ip: ANSIBLE_IP
    ansible.vm.provider PROVIDER do |vbox|
      vbox.memory = "4096"
      vbox.cpus = "2"
    end
    ansible.vm.provision "shell", inline: <<-SHELL
      sudo apt update -y
      sudo apt install software-properties-common -y
      sudo add-apt-repository --yes --update ppa:ansible/ansible -y
      sudo apt install ansible -y
      sudo apt-get install vim -y
      sudo apt-get install tree -y
    SHELL
  end
  ######################################
  ###   PROJECT 05 WEBSERVER WEB02   ### 
  ######################################
  config.vm.define "web02", autostart:false do |web02|
    web02.vm.box = CENTOS_VM
    web02.vm.hostname = 'web02'
    web02.vm.network "private_network", ip: WEB02_IP
    web02.vm.provider PROVIDER do |vbox|
      vbox.memory = "4096"
      vbox.cpus = "2"
    end
    web02.vm.provision "shell", inline: <<-SHELL
      echo "Universal Config Complete"
    SHELL
  end

  ######################################
  ###   PROJECT 05 WEBSERVER WEB03   ### 
  ######################################
  config.vm.define "web03", autostart:false do |web03|
    web03.vm.box = CENTOS_VM
    web03.vm.hostname = 'web03'
    web03.vm.network "private_network", ip: WEB03_IP
    web03.vm.provider PROVIDER do |vbox|
      vbox.memory = "4096"
      vbox.cpus = "2"
    end
    web03.vm.provision "shell", inline: <<-SHELL
      echo "Universal Config Complete"
    SHELL
  end
  ###############################
  ###   PROJECT 05 DATABASE   ### 
  ###############################
  config.vm.define "dbs02", autostart:false do |dbs02|
    dbs02.vm.box = CENTOS_VM
    dbs02.vm.hostname = 'dbs02'
    dbs02.vm.network "private_network", ip: DBS02_IP
    dbs02.vm.provider PROVIDER do |vbox|
      vbox.memory = "4096"
      vbox.cpus = "2"
    end
    dbs02.vm.provision "shell", inline: <<-SHELL
      echo "Universal Config Complete"
    SHELL
  end
  ####################################
  ### PROJECT 05 WEBSERVER WEB04   ### 
  ####################################
  config.vm.define "web04", autostart:false do |web04|
    web04.vm.box = UBUNTU_VM
    web04.vm.hostname = 'web04'
    web04.vm.network "private_network", ip: WEB04_IP
    web04.vm.provider PROVIDER do |vbox|
      vbox.memory = "4096"
      vbox.cpus = "2"
    end
    web04.vm.provision "shell", inline: <<-SHELL
      sudo apt update -y
      sudo apt-get install vim -y
    SHELL
  end

  ###########################################
  ### PROJECT 06 TOMCAT STAGING SERVER   #### 
  ###########################################
  config.vm.define "web05", autostart:false do |web05|
    web05.vm.box = PROJECT06_UBUNTU
    web05.vm.hostname = 'tomcat-staging06'
    web05.vm.network "private_network", ip: WEB05_IP
    web05.vm.provider PROVIDER do |vbox|
      vbox.memory = "4096"
      vbox.cpus = "2"
    end
    web05.vm.provision "shell", inline: <<-SHELL
      sudo apt update -y
      sudo apt-get install vim -y
      sudo useradd -m -G sudo jenkins
      echo "jenkins:myjenkinspassword123" | sudo chpasswd
    SHELL
  end
  #####################################
  ###   PROJECT 05 BACKEND SERVER   ### 
  #####################################
  config.vm.define "backend", autostart:false do |backend|
    backend.vm.box = CENTOS_VM
    backend.vm.hostname = 'backend'
    backend.vm.network "private_network", ip: BACKEND_IP
    backend.vm.provider PROVIDER do |vbox|
      vbox.memory = "4096"
      vbox.cpus = "2"
    end
    backend.vm.provision "shell", path: "backend-stack.sh"
  end
  ###############################
  ###   PROJECT 06 SELENIUM   ### 
  ###############################
  #config.vm.define "selenium", autostart:false do |selenium|
  #  selenium.vm.box = "gusztavvargadr/windows-server"
  #  selenium.vm.box_version = "2102.0.2404"
  #  selenium.vm.communicator="winrm"
  #  selenium.winrm.port=55985
  #  selenium.vm.hostname = 'selenium'
  #  selenium.vm.network "private_network", ip: SELENIUM_IP
  #  selenium.vm.provider PROVIDER do |vbox|
  #    vbox.memory = "4096"
  #    vbox.cpus = "2"
  #  end
  #  selenium.vm.provision "shell", inline: <<-SHELL
  #    <powershell>
  #    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  #    choco install jdk8 -y 
  #    choco install maven -y 
  #    choco install googlechrome -y
  #    choco install git -y
  #    mkdir C:\jenkins
  #    </powershell>
  #  SHELL
  #end



  ################################
  ###   Chapter 302: Docker   #### 
  ################################
  config.vm.define "docker", autostart:false do |docker|
    docker.vm.box = UBUNTU_VM
    docker.vm.hostname = 'docker'
    docker.vm.network "private_network", ip: DOCKER_IP
    docker.vm.provider PROVIDER do |vbox|
      vbox.memory = "8192"
      vbox.cpus = "4"
    end
    docker.vm.provision "shell", inline: <<-SHELL
      # Add Docker's official GPG key:
      sudo apt-get update -y
      sudo apt-get install -y maven vim
      sudo apt-get install ca-certificates curl -y
      sudo install -m 0755 -d /etc/apt/keyrings
      sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
      sudo chmod a+r /etc/apt/keyrings/docker.asc

      # Add the repository to Apt sources:
      echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      sudo apt-get update -y
      #Install "Latest"
      sudo apt-get install -y docker-compose docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      sudo apt-get upgrade -y
      sudo systemctl enable docker
      sudo systemctl start docker
      # Verify
      sudo systemctl status docker
      sudo docker run hello-world

      # Install the test website
      #sudo apt install wget unzip apache2 -y
      #cd /tmp
      #sudo wget https://www.tooplate.com/zip-templates/2137_barista_cafe.zip
      #unzip -o 2137_barista_cafe.zip
      #sudo mkdir -p /var/www/html
      #cp -r 2137_barista_cafe/* /var/www/html/

      # Start UFW
      #echo 'y' | sudo ufw enable
      #sudo ufw allow http
      #sudo ufw allow ssh
    SHELL
  end
end
