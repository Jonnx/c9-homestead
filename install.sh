#!/bin/bash

# Redirect stdout ( > ) into a named pipe ( >() ) running "tee"
exec > >(tee /tmp/installlog.txt)
# Without this, only stdout would be captured
exec 2>&1

# Check if sources.list is a symlink and make a copy so `apt-get update` succeeds
if [ -f /etc/apt/sources.list ] && [ -L /etc/apt/sources.list ]; then
  sudo mv /etc/apt/sources.list /etc/apt/sources.list.old
  sudo cp /etc/apt/sources.list.old /etc/apt/sources.list
fi

# Update Composer
sudo /usr/bin/composer self-update

# Add PHP7 Repository
LC_ALL=C.UTF-8 sudo add-apt-repository ppa:ondrej/php -y
sudo apt-add-repository ppa:rwky/redis -y

# Add MySQL 5.7
export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/repo-codename select trusty'
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/repo-distro select ubuntu'
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/repo-url string http://repo.mysql.com/apt/'
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-preview select '
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-product select Ok'
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-server select mysql-5.7'
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-tools select '
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/unsupported-platform select abort'
wget http://dev.mysql.com/get/mysql-apt-config_0.7.2-1_all.deb
dpkg -i mysql-apt-config_0.7.2-1_all.deb

#APT: Update
sudo apt-get update

# Install Stack
sudo apt-get -y install -qq php7.1 php7.1-fpm php7.1-cli php7.1-common php7.1-json php7.1-opcache php7.1-mysql php7.1-phpdbg \
php7.1-mbstring php7.1-gd php7.1-imap php7.1-ldap php7.1-pgsql php7.1-pspell php7.1-recode php7.1-tidy php7.1-dev \
php7.1-intl php7.1-gd php7.1-curl php7.1-zip php7.1-xml php7.1-mcrypt php7.1-sqlite php7.1-soap redis-server mysql-server-5.7 beanstalkd postgresql postgresql-contrib

sudo apt-get purge -qq apache2 mysql-server mysql-client

# Apache2
sudo service apache2 stop
# NGINX
sudo service nginx stop

# NGINX:
# Listen port 80, change document root, setup indexes, configure PHP sock
# set up the try_url thing (Drupal is not Worpress)...
# Thankfully, I already modified this in the repo!
sudo wget https://raw.githubusercontent.com/Jonnx/c9-homestead/php7.1/c9 --output-document=/etc/nginx/sites-available/c9
sudo chmod 755 /etc/nginx/sites-available/c9
sudo ln -s /etc/nginx/sites-available/c9 /etc/nginx/sites-enabled/c9


# PHP:
sudo sed -i 's/user = www-data/user = ubuntu/g' /etc/php/7.1/fpm/pool.d/www.conf
sudo sed -i 's/group = www-data/group = ubuntu/g' /etc/php/7.1/fpm/pool.d/www.conf
sudo sed -i 's/pm = dynamic/pm = ondemand/g' /etc/php/7.1/fpm/pool.d/www.conf # Reduce number of processes..

# Install helper
sudo wget https://raw.githubusercontent.com/Jonnx/c9-homestead/php7.1/cloudstead --output-document=/usr/bin/cloudstead
sudo chmod 755 /usr/bin/cloudstead

# Write phpinfo
echo "<?php phpinfo();" > /home/ubuntu/workspace/index.php

# Start the party!
cloudstead restart

clear;
echo "Cloudstead Install Complete";
echo "  - PHP Info: https://$C9_HOSTNAME";
