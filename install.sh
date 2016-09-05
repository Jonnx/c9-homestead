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

# Add PHP PPA Repository
LC_ALL=C.UTF-8 sudo add-apt-repository ppa:ondrej/php -y
sudo apt-add-repository ppa:rwky/redis -y
sudo apt-get update

# Install Stack
sudo apt-get -y install -qq php5.6 php5.6-fpm php5.6-cli php5.6-common php5.6-json php5.6-opcache php5.6-mysql php5.6-phpdbg \
php5.6-mbstring php5.6-gd php5.6-imap php5.6-ldap php5.6-pgsql php5.6-pspell php5.6-recode php5.6-tidy php5.6-dev \
php5.6-intl php5.6-gd php5.6-curl php5.6-zip php5.6-xml php5.6-mcrypt php5.6-sqlite php5.6-soap redis-server mysql-server beanstalkd postgresql postgresql-contrib

sudo apt-get purge -qq apache2 mysql-server mysql-client

# Apache2
sudo service apache2 stop
# NGINX
sudo service nginx stop

# NGINX:
# Listen port 80, change document root, setup indexes, configure PHP sock
# set up the try_url thing (Drupal is not Worpress)...
# Thankfully, I already modified this in the repo!
sudo wget https://raw.githubusercontent.com/Jonnx/c9-homestead/php5.6/c9 --output-document=/etc/nginx/sites-available/c9
sudo chmod 755 /etc/nginx/sites-available/c9
sudo ln -s /etc/nginx/sites-available/c9 /etc/nginx/sites-enabled/c9


# PHP:
sudo sed -i 's/user = www-data/user = ubuntu/g' /etc/php/5.6/fpm/pool.d/www.conf
sudo sed -i 's/group = www-data/group = ubuntu/g' /etc/php/5.6/fpm/pool.d/www.conf
sudo sed -i 's/pm = dynamic/pm = ondemand/g' /etc/php/5.6/fpm/pool.d/www.conf # Reduce number of processes..

# Install helper
sudo wget https://raw.githubusercontent.com/Jonnx/c9-homestead/php5.6/cloudstead --output-document=/usr/bin/cloudstead
sudo chmod 755 /usr/bin/cloudstead

# Write phpinfo
echo "<?php phpinfo();" > /home/ubuntu/workspace/index.php

# Start the party!
cloudstead restart

clear;
echo "Cloudstead Install Complete";
echo "  - PHP Info: https://$C9_HOSTNAME";
