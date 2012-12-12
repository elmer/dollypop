# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "precise64"

  # database node
  config.vm.define :database do |db|
    db.vm.host_name = "db.labs.vizcayano.com"
    db.vm.customize ["modifyvm", :id, "--memory", 1024]
    db.vm.network :hostonly, "10.50.10.50", :netmask => "255.255.255.0"

    db.vm.provision :shell,
      :inline => 'mkdir -p /etc/facter/facts.d; cp /vagrant/etc/database.yaml /etc/facter/facts.d/node.yaml'
    db.vm.provision :puppet, 
      :module_path => 'modules', :manifest_file => "site.pp", :options => [ "--debug" ]
  end

  # sample php app: drupal
  config.vm.define :drupal do |drupal|
    drupal.vm.host_name = "drupal.labs.vizcayano.com"
    drupal.vm.customize ["modifyvm", :id, "--memory", 1024]
    drupal.vm.network :hostonly, "10.50.10.51", :netmask => "255.255.255.0"

    drupal.vm.provision :shell,
      :inline => 'mkdir -p /etc/facter/facts.d; cp /vagrant/etc/drupal.yaml /etc/facter/facts.d/node.yaml'
    drupal.vm.provision :puppet, 
      :module_path => 'modules', :manifest_file => "site.pp", :options => [ "--debug" ]
  end

  # sample php app : wordpress
  config.vm.define :wordpress do |wp|
    wp.vm.host_name = "wp.labs.vizcayano.com"
    wp.vm.customize ["modifyvm", :id, "--memory", 1024]
    wp.vm.network :hostonly, "10.50.10.52", :netmask => "255.255.255.0"

    wp.vm.provision :shell,
      :inline => 'mkdir -p /etc/facter/facts.d; cp /vagrant/etc/wp.yaml /etc/facter/facts.d/node.yaml'
    wp.vm.provision :puppet, 
      :module_path => 'modules', :manifest_file => "site.pp", :options => [ "--debug" ]
  end

  # sample rails app :: redmine
  config.vm.define :redmine do |redmine|
    redmine.vm.host_name = "redmine.labs.vizcayano.com"
    redmine.vm.customize ["modifyvm", :id, "--memory", 1024]
    redmine.vm.network :hostonly, "10.50.10.53", :netmask => "255.255.255.0"

    redmine.vm.provision :shell,
      :inline => 'mkdir -p /etc/facter/facts.d; cp /vagrant/etc/redmine.yaml /etc/facter/facts.d/node.yaml'
    redmine.vm.provision :puppet,
      :module_path => 'modules', :manifest_file => "site.pp", :options => [ "--debug" ]
  end

  # sample java :: jforum on tomcat
  config.vm.define :jforum_tomcat do |tomcat|
    tomcat.vm.host_name = "jforum.labs.vizcayano.com"
    tomcat.vm.customize ["modifyvm", :id, "--memory", 1024]
    tomcat.vm.network :hostonly, "10.50.10.54", :netmask => "255.255.255.0"

    tomcat.vm.provision :shell,
      :inline => 'mkdir -p /etc/facter/facts.d; cp /vagrant/etc/jforum_tomcat.yaml /etc/facter/facts.d/node.yaml'
    tomcat.vm.provision :puppet,
      :module_path => 'modules', :manifest_file => "site.pp", :options => [ "--debug" ]
  end

  # sample java :: jforum on jboss
  config.vm.define :jforum_jboss do |jfjb|
    jfjb.vm.host_name = "jforumjb.labs.vizcayano.com"
    jfjb.vm.customize ["modifyvm", :id, "--memory", 1024]
    jfjb.vm.network :hostonly, "10.50.10.55", :netmask => "255.255.255.0"

    jfjb.vm.provision :shell,
      :inline => 'mkdir -p /etc/facter/facts.d; cp /vagrant/etc/jforum_jboss.yaml /etc/facter/facts.d/node.yaml'
    jfjb.vm.provision :puppet,
      :module_path => 'modules', :manifest_file => "site.pp", :options => [ "--debug" ]
  end

end
