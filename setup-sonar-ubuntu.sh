#!/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y unzip zip 
sudo apt-get install -y openjdk-11-jdk
cat << SYSCTL > /etc/sysctl.conf
vm.max_map_count=262144
fs.file-max=65536
ulimit -n 65536
ulimit -u 4096
SYSCTL


# Install Postgresql
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
sudo apt-get install postgresql postgresql-contrib -y

sudo systemctl enable postgresql
sudo systemctl start postgresql
sudo systemctl status postgresql
echo postgres:admin123 | sudo chpasswd
sudo runuser -l postgres -c "createuser sonar"
sudo -i -u postgres psql -c "ALTER USER sonar WITH ENCRYPTED PASSWORD 'admin123';"
sudo -i -u postgres psql -c "CREATE DATABASE sonarqube OWNER sonar;"
sudo -i -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar;"
sudo systemctl restart postgresql

# Install SonarQube
sudo mkdir -p /sonarqube
cd /sonarqube
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.3.0.34182.zip
sudo unzip -o sonarqube-8.3.0.34182.zip -d /opt
sudo mv /opt/sonarqube-8.3.0.34182/ /opt/sonarqube 
sudo groupadd sonar
sudo useradd -c "SonarQube - User" -d /opt/sonarqube/ -g sonar sonar
sudo chown sonar:sonar /opt/sonarqube -R

cat << PROPS > /opt/sonarqube/conf/sonar.properties
sonar.jdbc.username=sonar
sonar.jdbc.password=admin123
sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube
sonar.web.host=0.0.0.0
sonar.web.port=9000
sonar.web.javaAdditionalOpts=-server
sonar.search.javaOpts=-Xmx512m -Xms512m -XX:+HeapDumpOnOutOfMemoryError
sonar.log.level=INFO
sonar.path.logs=logs
PROPS

sudo sed -i 's/#RUN_AS_USER=/RUN_AS_USER=sonar/g' /opt/sonarqube/bin/linux-x86-64/sonar.sh

cat << SERVICE > /etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

User=sonar
Group=sonar
Restart=always

LimitNOFILE=65536
LimitNPROC=4096


[Install]
WantedBy=multi-user.target
SERVICE

sudo sysctl --system
sudo systemctl daemon-reload
sudo systemctl enable sonarqube.service
sudo systemctl start sonarqube.service
echo 'y' | sudo ufw enable
sudo ufw allow 9000/tcp
sudo ufw allow 9001/tcp
sudo ufw allow 5432/tcp
sudo ufw allow 22/tcp
sudo ufw reload