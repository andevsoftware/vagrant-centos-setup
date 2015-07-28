#!/usr/bin/env bash

# cleanup

sudo yum makecache fast

# General

sudo yum -y install git

sudo yum -y install gcc gcc-cpp gcc-c++

# General - Correct time
yum install ntp

ntpdate pool.ntp.org

# For file editing

sudo yum install nano


# Apache

sudo yum install httpd

sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
sudo firewall-cmd --reload


# Intl

sudo yum -y install libicu libicu-devel.x86_64 icu


# PHP

sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/epel-release.rpm
sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

sudo yum -y install php56w php56w-devel php56w-opcache php56w-common php56w-intl php56w-mbstring php56w-mcrypt php56w-mysql php56w-pdo php56w-pear


# MySQL (MariaDB)

sudo cp /vagrant/web/_server/config/MariaDB.repo /etc/yum.repos.d
sudo rpm --import http://yum.mariadb.org/RPM-GPG-KEY-MariaDB
sudo yum -y install MariaDB-server MariaDB-client

sudo /etc/init.d/mysql start

printf "\nY\nroot\nroot\nY\nY\nY\nY\n" | sudo mysql_secure_installation


#mysql -u root --password=root < /vagrant/web/_server/databases/database.sql


# Phalcon

sudo yum -y install libtool

cd /tmp
git clone git://github.com/phalcon/cphalcon.git
git checkout master
cd cphalcon/ext
sudo ./install


# XDebug

cd /tmp
wget http://xdebug.org/files/xdebug-2.3.2.tgz
tar -xvzf xdebug-2.3.2.tgz
cd xdebug-2.3.2
sudo phpize
sudo ./configure
sudo make
sudo cp modules/xdebug.so /usr/lib64/php/modules


# Memcached

sudo yum -y install memcached
sudo yum -y install php56w-pecl-memcache


# Create apache log dirs

# Remove config files

sudo rm -f /etc/httpd/conf.d/autoindex.conf
sudo rm -f /etc/httpd/conf.d/userdir.conf
sudo rm -f /etc/httpd/conf.d/welcome.conf

# Create symlink for config files
echo -e "\n\nIncludeOptional /vagrant/web/_server/conf_files/*.conf" | sudo tee -a /etc/httpd/conf/httpd.conf

sudo mkdir /var/log/httpd/custom
sudo ln -s /vagrant/web/_server/log_files/* /var/log/httpd/custom



sudo cp /vagrant/web/_server/config/php.ini /etc/php.ini
sudo cp /vagrant/web/_server/config/selinux /etc/sysconfig/selinux


echo -e "extension=phalcon.so" | sudo tee /etc/php.d/zzzzz.ini
echo -e "\n\nzend_extension = /usr/lib64/php/modules/xdebug.so\nxdebug.remote_enable = on\nxdebug.remote_connect_back = on\nxdebug.idekey = \"vagrant\"" | sudo tee -a /etc/php.ini


# Permissions

sudo chown -R apache:root /var/lib/php/session


# Start

sudo setenforce Permissive

sudo systemctl start httpd.service
sudo systemctl enable httpd.service

# Ruby
sudo yum -y install ruby

sudo yum -y install gcc g++ make automake autoconf curl-devel openssl-devel zlib-devel httpd-devel apr-devel apr-util-devel sqlite-devel
sudo yum -y install ruby-rdoc ruby-devel

sudo yum -y install rubygems

# Compass

gem update --system

gem install compass
