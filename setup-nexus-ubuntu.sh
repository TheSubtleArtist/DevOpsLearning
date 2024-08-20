#!/bin/bash

echo "Nexus"
NEXUSURL="https://download.sonatype.com/nexus/3/latest-unix.tar.gz"
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install wget openjdk-8-jdk -y
sudo useradd --system --no-create-home nexus
sudo mkdir -p /opt/nexus
sudo wget $NEXUSURL -O nexus.tar.gz
sudo tar -xzvf nexus.tar.gz
sudo mv nexus-3*/ nexus3
sudo rm -f nexus.tar.gz 
sudo mv * /opt/nexus

sudo chown -R nexus: /opt/nexus
sudo sed -i 's/#run_as_user=""/run_as_user="nexus"/g' /opt/nexus/nexus3/bin/nexus.rc
cat << VMO > /opt/nexus/nexus3/bin/nexus.vmoptions
-Xms1024m
-Xmx1024m
-XX:MaxDirectMemorySize=1024m

-XX:LogFile=/opt/nexus/sonatype-work/nexus3/log/jvm.log
-XX:-OmitStackTraceInFastThrow
-Djava.net.preferIPv4Stack=true
-Dkaraf.home=.
-Dkaraf.base=.
-Dkaraf.etc=etc/karaf
-Djava.util.logging.config.file=/etc/karaf/java.util.logging.properties
-Dkaraf.data=/opt/nexus/sonatype-work/nexus3
-Dkaraf.log=/opt/nexus/sonatype-work/nexus3/log
-Djava.io.tmpdir=/opt/nexus/sonatype-work/nexus3/tmp
-Dkaraf.startLocalConsole=false
-Djdk.tls.ephemeralDHKeySize=2048
VMO

cat << SERVICE > /etc/systemd/system/nexus.service
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus/nexus3/bin/nexus start
ExecStop=/opt/nexus/nexus3/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target
SERVICE


sudo systemctl enable nexus
sudo systemctl start nexus
echo 'y' | sudo ufw enable
sudo ufw allow 8081
sudo ufw allow 22
sudo ufw reload
sudo ufw show added
#sudo systemctl status nexus
