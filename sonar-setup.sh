#!/bin/bash

#Reference: https://linux.how2shout.com/how-to-install-sonarqube-on-ubuntu-22-04-lts-server/
echo "UPDATE"
sudo apt-get update -y
echo "UPGRADE"
sudo apt-get upgrade -y

echo "INSTALL DEPENDENCIES"
sudo apt-get install -y curl gnupg software-properties-common apt-transport-https lsb-release zip unzip openjdk-11-jdk 


echo "SYSCTL.CONF"
sudo sysctl -w vm.max_map_count=524288
sudo sysctl -w fs.file-max=131072
sudo ulimit -n 131072
sudo ulimit -u 8192

echo "LIMITS.CONF"
cat << EOT >> /etc/security/limits.conf
sonarqube   -   nofile   65536
sonarqube   -   nproc    4096
# End of File
EOT

sudo apt-get update -y
sudo apt-get upgrade -y

echo "ADD SONAR USER"
sudo groupadd sonar
sudo useradd -c "SonarQube - User" --system --no-create-home -g sonar sonar







#wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg >/dev/null

#sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
echo "deb [arch=amd64] http://apt.postgresql.org/pub/repos/apt/ jammy-pgdg main" | sudo tee /etc/apt/sources.list.d/postgresql.list >/dev/null

echo "INSTALL POSTGRES"
sudo apt-get update -y 

sudo apt install -y postgresql-10 postgresql-contrib 
#sudo -u postgres psql -c "SELECT version();"
sudo systemctl enable postgresql.service
sudo systemctl start  postgresql.service
echo "postgres:admin123" | sudo chpasswd
sudo runuser -l postgres -c "createuser sonar"
sudo -i -u postgres psql -c "ALTER USER sonar WITH ENCRYPTED PASSWORD 'admin123';"
sudo -i -u postgres psql -c "CREATE DATABASE sonarqube OWNER sonar;"
sudo -i -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar;"
sudo systemctl restart postgresql

echo "DOWNLOAD SONARQUBE"
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.0.65466.zip
sudo unzip -o sonarqube-9.9.0.65466.zip 
sudo mv sonarqube-*/ /opt/sonarqube

sudo chown -R sonar:sonar /opt/sonarqube

echo "SONAR.PROPERTIES"
cat << EOT > /opt/sonarqube/conf/sonar.properties
sonar.jdbc.username=sonar
sonar.jdbc.password=admin123
sonar.jdbc.url=jdbc:postgresql:5432//localhost/opt/sonarqube
sonar.web.host=0.0.0.0
sonar.web.port=9000
sonar.web.javaAdditionalOpts=-server
sonar.search.javaOpts=-Xmx512m -Xms512m -XX:+HeapDumpOnOutOfMemoryError
sonar.log.level=INFO
sonar.path.logs=logs
EOT

echo "SONARQUBE.SERVICE"
cat << EOT > /etc/systemd/system/sonarqube.service
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
EOT

sudo systemctl daemon-reload
sudo systemctl enable sonarqube.service
sudo systemctl start sonarqube.service
#systemctl status -l sonarqube.service

echo "INSTALL NGINX"
sudo apt-get install -y nginx
sudo rm -rf /etc/nginx/sites-enabled/default >/dev/null
sudo rm -rf /etc/nginx/sites-available/default >/dev/null
cat << EOT > /etc/nginx/sites-available/sonarqube
server{
    listen      80;
    server_name sonarqube;

    access_log  /var/log/nginx/sonar.access.log;
    error_log   /var/log/nginx/sonar.error.log;

    proxy_buffers 16 64k;
    proxy_buffer_size 128k;

    location / {
        proxy_pass  http://127.0.0.1:9000;
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
        proxy_redirect off;
              
        proxy_set_header    Host            \$host;
        proxy_set_header    X-Real-IP       \$remote_addr;
        proxy_set_header    X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header    X-Forwarded-Proto http;
    }
}
EOT

sudo ln -s /etc/nginx/sites-available/sonarqube /etc/nginx/sites-enabled/sonarqube
sudo systemctl enable nginx.service
sudo systemctl start nginx.service
sudo systemctl status nginx.service
#systemctl restart nginx.service
sudo systemctl daemon-reload
echo 'y' | sudo ufw enable
sudo ufw allow 80/tcp
sudo ufw allow 5432/tcp
sudo ufw allow 9000/tcp
sudo ufw allow 9001/tcp
sudo ufw reload

sleep 30 
sudo reboot

