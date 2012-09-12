# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "precise64"
  config.vm.define :db do |db|
    db.vm.host_name = "db.labs.vizcayano.com"
    db.vm.customize ["modifyvm", :id, "--memory", 1024]
    db.vm.network :hostonly, "10.50.10.50", :netmask => "255.255.255.0"

    db.vm.provision :puppet, :manifest_file => "site.pp", :options => [ "--debug" ]
  end
end
