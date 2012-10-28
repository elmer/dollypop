# redmine app
class stack::apps::redmine {
  include stack::rails
  include apache # for proxy
  include apache::mod::proxy
  include apache::mod::proxy_http

  $redmine_home = '/var/lib/redmine'
  $redmine_user = 'redmine'

  $site_name = $::site_name
  $doc_root = "${redmine_home}/redmine-2.1.0/public"

  file {'/etc/apache2/sites-enabled/10-redmine-vhost.conf':
    ensure  => present,
    content => template('stack/redmine/redmine_apache_vhost.erb'),
    require => Package['httpd'],
    notify  => Service['httpd'],
  }

  user { $redmine_user:
    ensure  => present,
    comment => 'Redmine Power User',
    shell   => '/bin/bash',
    home    => $redmine_home,
  }

  file { $redmine_home:
    ensure  => directory,
    owner   => $redmine_user,
    group   => $redmine_user,
    require => User[$redmine_user],
  }

  rvm::define::user { $redmine_user:
    require => User[$redmine_user],
  }

  rvm::define::gemset{ 'redmine':
    ensure       => present,
    ruby_version => 'ruby-1.9.2',
  }

  class {'stack::apps::redmine_install':
    path    => $redmine_home,
    owner   => $redmine_user,
    stage   => deploy,
    require => Rvm::Define::Gemset['redmine'],
  }



}
