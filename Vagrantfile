# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

Vagrant.configure(2) do |config|

  config.vm.box = "relativkreativ/centos-7-minimal"

  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provision :shell, path: "_server/bootstrap.sh"

  config.trigger.after [:provision, :up, :reload] do

        system('vagrant ssh --command "sudo service httpd restart"')

        system('echo "
          rdr pass on lo0 inet proto tcp from any to 127.0.0.1 port 80 -> 127.0.0.1 port 8080  
          rdr pass on lo0 inet proto tcp from any to 127.0.0.1 port 443 -> 127.0.0.1 port 4443
    " | sudo pfctl -ef - > /dev/null 2>&1; echo "==> Fowarding Ports: 80 -> 8080, 443 -> 4443 & Enabling pf"')  
    end

    config.trigger.after [:halt, :destroy] do
      system("sudo pfctl -df /etc/pf.conf > /dev/null 2>&1; echo '==> Removing Port Forwarding & Disabling pf'")
    end

end
