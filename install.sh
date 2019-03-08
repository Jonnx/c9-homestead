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

# UI Flow for MySQL 5.7
wget http://dev.mysql.com/get/mysql-apt-config_0.6.0-1_all.deb
sudo dpkg -i mysql-apt-config_0.6.0-1_all.deb

#APT: Update
sudo apt-get update

# Install Stack
sudo apt-get -y --force-yes install -qq php7.2 php7.2-fpm php7.2-cli php7.2-common php7.2-opcache php7.2-zip php7.2-dom php7.2-mbstring php7.2-curl php7.2-mysql redis-server mysql-server beanstalkd postgresql postgresql-contrib

# install cleanup
sudo apt-get purge -qq apache2
sudo rm ./mysql-apt-config_0.6.0-1_all.deb

# Apache2
sudo service apache2 stop
# NGINX
sudo service nginx stop

# NGINX:
# Listen port 80, change document root, setup indexes, configure PHP sock
# set up the try_url thing (Drupal is not Worpress)...
# Thankfully, I already modified this in the repo!
sudo wget https://raw.githubusercontent.com/Jonnx/c9-homestead/php7.2/c9 --output-document=/etc/nginx/sites-available/c9
sudo chmod 755 /etc/nginx/sites-available/c9
sudo ln -s /etc/nginx/sites-available/c9 /etc/nginx/sites-enabled/c9

# CONFIGURE COMPOSER GLOBAL
sudo chown -R ubuntu /home/ubuntu/.composer
sudo echo "" >> ~/.profile
sudo echo "# COMPOSER GLOBAL" >> ~/.profile
sudo echo "export PATH=$PATH:/home/ubuntu/.composer/vendor/bin" >> ~/.profile

# PHP:
sudo sed -i 's/user = www-data/user = ubuntu/g' /etc/php/7.2/fpm/pool.d/www.conf
sudo sed -i 's/group = www-data/group = ubuntu/g' /etc/php/7.2/fpm/pool.d/www.conf
sudo sed -i 's/pm = dynamic/pm = ondemand/g' /etc/php/7.2/fpm/pool.d/www.conf # Reduce number of processes..

# Install helper
sudo wget https://raw.githubusercontent.com/Jonnx/c9-homestead/php7.2/cloudstead --output-document=/usr/bin/cloudstead
sudo chmod 755 /usr/bin/cloudstead

# Write phpinfo
echo "<?php phpinfo();" > /home/ubuntu/workspace/index.php

# Start the party!
cloudstead restart

clear;
echo "Cloudstead Install Complete";
echo "  - PHP Info: https://$C9_HOSTNAME";
