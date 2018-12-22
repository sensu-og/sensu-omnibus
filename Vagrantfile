# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vm.define "ubuntu", default: true, autostart: false do |ubuntu|
    # The most common configuration options are documented and commented below.
    # For a complete reference, please see the online documentation at
    # https://docs.vagrantup.com.

    # Every Vagrant development environment requires a box. You can search for
    # boxes at https://vagrantcloud.com/search.
    ubuntu.vm.box = "ubuntu/xenial64"

    # Disable automatic box update checking. If you disable this, then
    # boxes will only be checked for updates when the user runs
    # `vagrant box outdated`. This is not recommended.
    # config.vm.box_check_update = false

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    # NOTE: This will enable public access to the opened port
    # config.vm.network "forwarded_port", guest: 80, host: 8080

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine and only allow access
    # via 127.0.0.1 to disable public access
    # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    # config.vm.network "private_network", ip: "192.168.33.10"

    # Create a public network, which generally matched to bridged network.
    # Bridged networks make the machine appear as another physical device on
    # your network.
    ubuntu.vm.network "public_network"

    # Share an additional folder to the guest VM. The first argument is
    # the path on the host to the actual folder. The second argument is
    # the path on the guest to mount the folder. And the optional third
    # argument is a set of non-required options.
    ubuntu.vm.synced_folder ".", "/home/vagrant/sensu"

    # Provider-specific configuration so you can fine-tune various
    # backing providers for Vagrant. These expose provider-specific options.
    # Example for VirtualBox:
    #
    # config.vm.provider "virtualbox" do |vb|
    #   # Display the VirtualBox GUI when booting the machine
    #   vb.gui = true
    #
    #   # Customize the amount of memory on the VM:
    #   vb.memory = "1024"
    # end
    #
    # View the documentation for the provider you are using for more
    # information on available options.

    # Enable provisioning with a shell script. Additional provisioners such as
    # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
    # documentation for more information about their specific syntax and use.
    ubuntu.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get -y install build-essential patch
      apt-get -y install ruby-dev zlib1g-dev liblzma-dev
      mkdir -p /var/cache
      mkdir -p /etc/sensu
      mkdir -p /opt/sensu
      mkdir -p /var/log/sensu
      mkdir -p /var/run/sensu
      mkdir -p /etc/default
      chown vagrant:vagrant /var/cache
      chown vagrant:vagrant /etc/sensu
      chown vagrant:vagrant /opt/sensu
      chown vagrant:vagrant /var/log/sensu
      chown vagrant:vagrant /var/run/sensu
      chown vagrant:vagrant /lib/systemd/system
      chown vagrant:vagrant /etc/logrotate.d
      chown vagrant:vagrant /etc/default
      chown vagrant:vagrant /usr/bin
      chown vagrant:vagrant /etc/tmpfiles.d
      wget https://packages.chef.io/files/stable/chefdk/2.5.3/ubuntu/16.04/chefdk_2.5.3-1_amd64.deb
      dpkg -i chefdk_2.5.3-1_amd64.deb
      echo "export PATH=/opt/chefdk/bin:$PATH" >> /home/vagrant/.bashrc
      echo 'eval "$(chef shell-init bash)"' >> /home/vagrant/.bashrc
      echo 'export SENSU_VERSION=1.3.3' >> /home/vagrant/.bashrc
      echo 'export BUILD_NUMBER=3000' >> /home/vagrant/.bashrc
      runuser -l vagrant -c 'git config --global user.name "Sensu Inc"'
      runuser -l vagrant -c 'git config --global user.email "build@sensu.io"'
    SHELL
  end

  config.vm.define "centos", default: true, autostart: false do |centos|
    # Bento centos7 box 
    centos.vm.box = "bento/centos-7"
    centos.vm.hostname = 'centos'

    #centos.vm.network "public_network"
    centos.vm.synced_folder ".", "/home/vagrant/sensu"
    # Support virtualbox provider
    centos.vm.provider "virtualbox" do |vb, vboxoverride|
      vb.cpus = 2
      vb.memory = 2048
      vb.name = "sensu-omnibus-centos-x86-64"
    end



    # Enable provisioning with a shell script. Additional provisioners such as
    # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
    # documentation for more information about their specific syntax and use.
    centos.vm.provision "shell", inline: <<-SHELL
     yum -y update
     yum -y groupinstall "Development Tools"
     yum -y install ruby-devel

     mkdir -p /var/cache
     mkdir -p /etc/sensu
     mkdir -p /opt/sensu
     mkdir -p /var/log/sensu
     mkdir -p /var/run/sensu
     mkdir -p /etc/default
     chown vagrant:vagrant /var/cache
     chown vagrant:vagrant /etc/sensu
     chown vagrant:vagrant /opt/sensu
     chown vagrant:vagrant /var/log/sensu
     chown vagrant:vagrant /var/run/sensu
     chown vagrant:vagrant /lib/systemd/system
     chown vagrant:vagrant /etc/logrotate.d
     chown vagrant:vagrant /etc/default
     chown vagrant:vagrant /usr/bin
     chown vagrant:vagrant /etc/tmpfiles.d
     chmod u+rwx /usr/bin/
     chmod u+rwx /var/run/
     chmod u+rwx /var/log/
     ##
     #  Change permissions to match sensu-go packaging to avoid package conflicts
     ##
     chmod 0750 /var/log/sensu
     chmod 0750 /var/run/sensu

     wget -nc -q https://packages.chef.io/files/stable/chefdk/3.5.13/el/7/chefdk-3.5.13-1.el7.x86_64.rpm
     rpm -U chefdk-3.5.13-1.el7.x86_64.rpm 
     echo "export PATH=/opt/chefdk/bin:$PATH" >> /home/vagrant/.bashrc
     echo 'eval "$(chef shell-init bash)"' >> /home/vagrant/.bashrc
     echo 'export SENSU_VERSION=1.6.2' >> /home/vagrant/.bashrc
     echo 'export BUILD_NUMBER=3000' >> /home/vagrant/.bashrc
     runuser -l vagrant -c 'git config --global user.name "Sensu Inc"'
     runuser -l vagrant -c 'git config --global user.email "build@sensu.io"'
   SHELL
  end

end
