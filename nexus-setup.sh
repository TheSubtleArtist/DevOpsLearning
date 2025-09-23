#!/bin/bash

# Reference: https://devopscube.com/how-to-install-latest-sonatype-nexus-3-on-linux/
sudo yum update -y
sudo yum install -y wget
sudo yum install -y java-1.8.0-openjdk.x86_6

sudo mkdir -p /opt/nexus
#NEXUSURL="https://download.sonatype.com/nexus/3/latest-unix.tar.gz"
NEXUSURL="https://download.sonatype.com/nexus/3/nexus-3.70.1-02-java8-unix.tar.gz"


wget $NEXUSURL -O nexus.tar.gz 
sudo tar -xzvf nexus.tar.gz
sudo mv nexus-3*/ nexus3
#sudo rm -f nexus.tar.gz
sudo mv * /opt/nexus

useradd --system --no-create-home nexus
sudo chown -R nexus:nexus /opt/nexus 

sudo sed -i 's/#run_as_user=""/run_as_user="nexus"/g' /opt/nexus/nexus3/bin/nexus.rc

echo "NEXUS.SERVICE"
cat << NXS > /etc/systemd/system/nexus.service
[Unit]
Description=nexus service
After=syslog.target network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/opt/nexus/nexus3/bin/nexus start
ExecStop=/opt/nexus/nexus3/bin/nexus stop
Restart=on-abort

[Install]
WantedBy=multi-user.target                                                    
NXS

cat << NXO > /opt/nexus/nexus3/bin/nexus.vmoptions
-Xms2703m
-Xmx2703m
-XX:MaxDirectMemorySize=2703m
-XX:+UnlockDiagnosticVMOptions
-XX:+LogVMOutput
-XX:LogFile=/opt/nexus/sonatype-work/nexus3/log/jvm.log
-XX:-OmitStackTraceInFastThrow
-Djava.net.preferIPv4Stack=true
-Dkaraf.home=.
-Dkaraf.base=.
-Dkaraf.etc=etc/karaf
-Djava.util.logging.config.file=etc/karaf/java.util.logging.properties
-Dkaraf.data=/opt/nexus/sonatype-work/nexus3
-Dkaraf.log=/opt/nexus/sonatype-work/nexus3/log
-Djava.io.tmpdir=/opt/nexus/sonatype-work/nexus3/tmp
-Dkaraf.startLocalConsole=false
NXO


sudo chcon -R -t bin_t /opt/nexus/nexus3/bin/nexus # add a SELinux policy to allow Systemd to access the nexus binary
sudo systemctl daemon-reload
sudo systemctl start nexus
sudo systemctl enable nexus
sudo systemctl status nexus

sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --add-port=8081/tcp --permanent --zone=public
sudo firewall-cmd --reload

sudo cat /opt/nexus/sonatype-work/nexus3/admin.password




