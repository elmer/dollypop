# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "precise64"
  config.vm.define :db do |db|
    db.vm.host_name = "db.labs.vizcayano.com"
    db.vm.customize ["modifyvm", :id, "--memory", 1024]
    db.vm.network :hostonly, "10.50.10.50", :netmask => "255.255.255.0"

    db.vm.provision :shell,
      :inline => 'mkdir -p /etc/facter/facts.d; cp /vagrant/etc/database.yaml /etc/facter/facts.d/node.yaml'
    db.vm.provision :puppet, 
      :module_path => 'modules', :manifest_file => "site.pp", :options => [ "--debug" ]
  end

  # sample drupal app
  config.vm.define :drupal do |drupal|
    drupal.vm.host_name = "drupal.labs.vizcayano.com"
    drupal.vm.customize ["modifyvm", :id, "--memory", 1024]
    drupal.vm.network :hostonly, "10.50.10.51", :netmask => "255.255.255.0"

    drupal.vm.provision :shell,
      :inline => 'mkdir -p /etc/facter/facts.d; cp /vagrant/etc/drupal.yaml /etc/facter/facts.d/node.yaml'
    drupal.vm.provision :puppet, 
      :module_path => 'modules', :manifest_file => "site.pp", :options => [ "--debug" ]
  end
end
