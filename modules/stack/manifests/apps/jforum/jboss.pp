# jforum on jboss
class stack::apps::jforum::jboss {

  $jboss_user = 'jboss'
  $jboss_file = 'jboss-as-7.1.1.Final.tar.gz'
  $jboss_url  = "http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/${jboss_file}"
  $jboss_home = '/usr/local/jboss'

  user { $jboss_user:
    ensure     => present,
    home       => $jboss_home,
    shell      => '/bin/sh',
    managehome => true,
  }

  exec { 'download-jboss-7.1.1-final':
    path    => '/usr/bin',
    cwd     => $jboss_home,
    command => "wget -c ${jboss_url}",
    unless  => "test -f ${jboss_home}/${jboss_file}",
    timeout => 0,
    require => User[$jboss_user],
  }

  exec { 'untar-jboss-archive':
    cwd     => $jboss_home,
    command => "/bin/tar -xzf ${jboss_file}",
    require => Exec['download-jboss-7.1.1-final'],
    unless  => '/usr/bin/test -f jboss-as-7.1.1.Final/jboss-modules.jar',
  }

  exec { 'ensure-jboss-ownership':
    command => "/bin/chown -R ${jboss_user}:${jboss_user} ${jboss_home}/jboss-as-7.1.1.Final",
    require => Exec['untar-jboss-archive'],
  }

  file { "${jboss_home}/jboss-as":
    ensure  => link,
    target  => "${jboss_home}/jboss-as-7.1.1.Final",
    owner   => $jboss_user,
    group   => $jboss_user,
    require => Exec['untar-jboss-archive'],
  }

  file { '/var/log/jboss-as':
    ensure  => directory,
    owner   => $jboss_user,
    group   => $jboss_user,
    require => User[$jboss_user],
  }

  file { '/var/run/jboss-as':
    ensure  => directory,
    owner   => $jboss_user,
    group   => $jboss_user,
    require => User[$jboss_user],
  }

  file { '/etc/init.d/jboss-as':
    ensure  => present,
    mode    => '0755',
    content => template('stack/jboss/jboss-init.sh.erb'),
    require => Exec['untar-jboss-archive'],
  }

  # standalone jboss config
  file { "${jboss_home}/jboss-as/standalone/configuration/standalone.xml":
    ensure => present,
    owner  => $jboss_user,
    group  => $jboss_user,
    source => 'puppet:///modules/stack/jboss/standalone.xml',
    require => File["${jboss_home}/jboss-as"],
  }

  file { "${jboss_home}/jboss-as/standalone/data":
    ensure  => directory,
    owner   => $jboss_user,
    group   => $jboss_user,
    require => File["${jboss_home}/jboss-as"],
  }

  file { "${jboss_home}/jboss-as/standalone/log":
    ensure  => directory,
    owner   => $jboss_user,
    group   => $jboss_user,
    require => File["${jboss_home}/jboss-as"],
  }

  file { "${jboss_home}/jboss-as/standalone/tmp":
    ensure  => directory,
    owner   => $jboss_user,
    group   => $jboss_user,
    require => File["${jboss_home}/jboss-as"],
  }

  file { "${jboss_home}/jboss-as/standalone/deployments":
    ensure  => directory,
    owner   => $jboss_user,
    group   => $jboss_user,
    require => File["${jboss_home}/jboss-as"],
  }


  # Jforum installation
  package {'unzip': ensure => installed }

  $jforum = 'jforum-2.1.9'
  $jboss_apps = '/srv/jboss-apps'
  $jforum_home = "${jboss_apps}/jforum"

  file { $jboss_apps:
    ensure => directory,
    owner  => $jboss_user,
    group  => $jboss_user,
  }

  file { $jforum_home:
    ensure  => directory,
    owner   => $jboss_user,
    group   => $jboss_user,
    require => File[$jboss_apps],
  }

  exec { "fetch-jforum-zipfile-${jforum}":
    command => "/usr/bin/wget http://jforum.net/${jforum}.zip",
    cwd     => $jforum_home,
    unless  => "/usr/bin/test -f ${jforum_home}/${jforum}.zip",
    require => Package['unzip']
  }

  exec { "jforum-unzip-${jforum}":
    command => "/usr/bin/unzip ${jforum}",
    cwd     => $jforum_home,
    unless  => "/usr/bin/test -f ${jforum_home}/${jforum}/install.jsp",
    require => Exec["fetch-jforum-zipfile-${jforum}"],
  }

  exec { 'ensure-jboss-owner':
    command => "/bin/chown -R ${jboss_user}:${jboss_user} ${jforum}",
    cwd     => $jforum_home,
    require => Exec["jforum-unzip-${jforum}"],
  }

  exec { "deploy-to-web-root-${jforum}":
    command => "/bin/mv ${jforum} ${jboss_home}/jboss-as/standalone/deployments/ROOT.war",
    cwd     => $jforum_home,
    unless  => "/usr/bin/test -f ${jboss_home}/jboss-as/standalone/deployments/ROOT.war/WEB-INF/web.xml",
    require => [Exec['ensure-jboss-owner'],
                File["${jboss_home}/jboss-as/standalone/deployments"]],
    notify => Service['jboss-as'],
  }

  exec { 'trigger-deploy-jforum':
    command => "/usr/bin/touch ${jboss_home}/jboss-as/standalone/deployments/ROOT.war.dodeploy",
    user    => $jboss_user,
    group   => $jboss_user,
    notify  => Service['jboss-as']
  }

  service { 'jboss-as':
    ensure  => running,
    require => Exec["deploy-to-web-root-${jforum}"],
  }


}
