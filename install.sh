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

# Add PHP7.0 Repository
LC_ALL=C.UTF-8 sudo add-apt-repository ppa:ondrej/php -y
sudo apt-add-repository ppa:rwky/redis -y
sudo apt-get update

# Install Stack
sudo apt-get -y install -qq php7.0 php7.0-fpm php7.0-cli php7.0-common php7.0-json php7.0-opcache php7.0-mysql php7.0-phpdbg \
php7.0-mbstring php7.0-gd php7.0-imap php7.0-ldap php7.0-pgsql php7.0-pspell php7.0-recode php7.0-tidy php7.0-dev \
php7.0-intl php7.0-gd php7.0-curl php7.0-zip php7.0-xml php7.0-mcrypt php7.0-sqlite php7.0-soap redis-server mysql-server beanstalkd postgresql postgresql-contrib

sudo apt-get purge -qq apache2 mysql-server mysql-client

# Apache2
sudo service apache2 stop
# NGINX
sudo service nginx stop

# NGINX:
# Listen port 80, change document root, setup indexes, configure PHP sock
# set up the try_url thing (Drupal is not Worpress)...
# Thankfully, I already modified this in the repo!
sudo wget https://raw.githubusercontent.com/Jonnx/c9-homestead/php7.0/c9 --output-document=/etc/nginx/sites-available/c9
sudo chmod 755 /etc/nginx/sites-available/c9
sudo ln -s /etc/nginx/sites-available/c9 /etc/nginx/sites-enabled/c9


# PHP:
sudo sed -i 's/user = www-data/user = ubuntu/g' /etc/php/7.0/fpm/pool.d/www.conf
sudo sed -i 's/group = www-data/group = ubuntu/g' /etc/php/7.0/fpm/pool.d/www.conf
sudo sed -i 's/pm = dynamic/pm = ondemand/g' /etc/php/7.0/fpm/pool.d/www.conf # Reduce number of processes..

# Install helper
sudo wget https://raw.githubusercontent.com/Jonnx/c9-homestead/php7.0/cloudstead --output-document=/usr/bin/cloudstead
sudo chmod 755 /usr/bin/cloudstead

# Write phpinfo
echo "<?php phpinfo();" > /home/ubuntu/workspace/index.php

# Start the party!
cloudstead restart

clear;
echo "Cloudstead Install Complete";
echo "  - PHP Info: https://$C9_HOSTNAME";
