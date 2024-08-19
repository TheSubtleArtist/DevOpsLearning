#!/bin/bash

# UBUNTU 20.04

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