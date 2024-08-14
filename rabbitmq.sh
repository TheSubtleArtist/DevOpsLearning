#!/bin/bash
sudo yum install epel-release -y
sudo yum update -y
sudo yum install wget -y

cat << EOF > /etc/yum.repos.d/modern_erlang.repo
# In /etc/yum.repos.d/modern_erlang.repo

##
## Zero dependency Erlang RPM
##

[modern-erlang]
name=modern-erlang-el8
# uses a Cloudsmith mirror @ yum.novemberain.com in addition to its Cloudsmith upstream.
# Unlike Cloudsmith, the mirror is very unlikely to hit its traffic quota
baseurl=https://yum1.novemberain.com/erlang/el/8/$basearch
        https://yum2.novemberain.com/erlang/el/8/$basearch
repo_gpgcheck=1
enabled=1
gpgkey=https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/gpg.E495BB49CC4BBE5B.key
gpgcheck=1
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
pkg_gpgcheck=1
autorefresh=1
type=rpm-md

[modern-erlang-noarch]
name=modern-erlang-el8-noarch
# uses a Cloudsmith mirror @ yum.novemberain.com.
# Unlike Cloudsmith, the mirror is very unlikely to hit its traffic quotas
baseurl=https://yum1.novemberain.com/erlang/el/8/noarch
        https://yum2.novemberain.com/erlang/el/8/noarch
repo_gpgcheck=1
enabled=1
gpgkey=https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/gpg.E495BB49CC4BBE5B.key
       https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc
gpgcheck=1
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
pkg_gpgcheck=1
autorefresh=1
type=rpm-md

[modern-erlang-source]
name=modern-erlang-el8-source
# uses a Cloudsmith mirror @ yum.novemberain.com.
# Unlike Cloudsmith, the mirror is very unlikely to hit its traffic quotas
baseurl=https://yum1.novemberain.com/erlang/el/8/SRPMS
        https://yum2.novemberain.com/erlang/el/8/SRPMS
repo_gpgcheck=1
enabled=1
gpgkey=https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/gpg.E495BB49CC4BBE5B.key
       https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc
gpgcheck=1
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
pkg_gpgcheck=1
autorefresh=1
EOF


cat << EOF > /etc/yum.repos.d/rabbitmq.repo

[rabbitmq-el9]
name=rabbitmq-el9
baseurl=https://yum2.novemberain.com/rabbitmq/el/9/$basearch
        https://yum1.novemberain.com/rabbitmq/el/9/$basearch
        https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-server/rpm/el/9/$basearch
repo_gpgcheck=1
enabled=1
# Cloudsmith's repository key and RabbitMQ package signing key
gpgkey=https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-server.9F4587F226208342.key
       https://github.com/rabbitmq/signing-keys/releases/download/3.0/rabbitmq-release-signing-key.asc
gpgcheck=1
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
pkg_gpgcheck=1
autorefresh=1
type=rpm-md

[rabbitmq-el9-noarch]
name=rabbitmq-el9-noarch
baseurl=https://yum2.novemberain.com/rabbitmq/el/9/noarch
        https://yum1.novemberain.com/rabbitmq/el/9/noarch
        https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-server/rpm/el/9/noarch
repo_gpgcheck=1
enabled=1
# Cloudsmith's repository key and RabbitMQ package signing key
gpgkey=https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-server.9F4587F226208342.key
       https://github.com/rabbitmq/signing-keys/releases/download/3.0/rabbitmq-release-signing-key.asc
gpgcheck=1
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
pkg_gpgcheck=1
autorefresh=1
type=rpm-md

[rabbitmq-el9-source]
name=rabbitmq-el9-source
baseurl=https://yum2.novemberain.com/rabbitmq/el/9/SRPMS
        https://yum1.novemberain.com/rabbitmq/el/9/SRPMS
        https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-server/rpm/el/9/SRPMS
repo_gpgcheck=1
enabled=1
gpgkey=https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-server.9F4587F226208342.key
gpgcheck=0
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
pkg_gpgcheck=1
autorefresh=1
type=rpm-md
EOF

sudo dnf update -y
sudo dnf install socat logrotate -y
sudo dnf install -y erlang rabbitmq-server

systemctl enable --now rabbitmq-server
systemctl start rabbitmq-server
firewall-cmd --add-port=5672/tcp --zone=public --permanent
firewall-cmd --reload

sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator
sudo systemctl restart rabbitmq-server
