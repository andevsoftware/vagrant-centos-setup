# vagrant-centos-setup #

**This setup is only tested on OS X Yosemite**

## Server ##

Take a look at /_server/bootstrap.sh to see what gets installed on this server.

## Requirements ##
You need to have at least (VirtualBox, VMWare..) and Vagrant installed.


## Setup ##

### Step 1 ###
````
git clone https://github.com/olivierandriessen/vagrant–centos-setup
````

### Step 2 ###
````
vagrant plugin install vagrant-triggers
````

### Step 3 ###
````
vagrant up
````

## Create virtual hosts ##

### Step 1 ###
Create a new domainname.conf file inside /web/_server/conf_files with for example the following configuration
````
<VirtualHost *:80>

    <Directory "/vagrant/web/docroots/domainname">

        Options FollowSymLinks

        AllowOverride All

        Require all granted

    </Directory>

    ServerName domainname.com
    ServerAlias www.domainname.com

    DocumentRoot /vagrant/web/docroots/domainname

    SetEnv APPLICATION_ENV "development"

    AddDefaultCharset UTF-8

    ErrorLog "|/usr/sbin/rotatelogs /vagrant/web/_server/log_files/vagrantserver/domainname/error_log.%Y%m%d.log 86400"
    CustomLog "|/usr/sbin/rotatelogs /vagrant/web/_server/log_files/vagrantserver/domainname/access_log.%Y%m%d.log 86400" combined

</VirtualHost>
````

### Step 2 ###
You can either restart the vagrant server
````
vagrant halt
vagrant up
````

Or gain access to the server using ssh and restart apache
````
vagrant ssh
sudo service httpd restart
````

### Step 3 ###
Then, your browser needs to know where to look when you enter domainnname.com  
Open up terminal and type the following command
````
sudo nano /etc/hosts
````

And add the following line
````
127.0.0.1 domainname.com
````  

Done!