# jforum on tomcat installation
class stack::apps::jforum::tomcat::install {

  tomcat::instance { 'jforum':
    ensure      => 'present',
    server_port => '8001',
    http_port   => '8080',
  }

  package {'unzip': ensure => installed }

  $jforum = 'jforum-2.1.9'
  $jforum_home = '/srv/tomcat/jforum'

  exec { "jforum-zipfile-${jforum}":
    command => "/usr/bin/wget http://jforum.net/${jforum}.zip",
    cwd     => $jforum_home,
    unless  => "/usr/bin/test -f ${jforum_home}/${jforum}.zip",
    require => Package['unzip']
  }

  exec { "jforum-unzip-${jforum}":
    command => "/usr/bin/unzip ${jforum}",
    cwd     => $jforum_home,
    require => Exec["jforum-zipfile-${jforum}"],
  }

  exec { 'ensure-owner':
    command => "/bin/chown -R tomcat:tomcat ${jforum}",
    cwd     => $jforum_home,
    require => Exec["jforum-unzip-${jforum}"],
  }

  exec { "deploy-to-web-root-${jforum}":
    command => "/bin/mv ${jforum} ${jforum_home}/webapps/ROOT",
    cwd     => $jforum_home,
    unless  => "/usr/bin/test -f ${jforum_home}/webapps/ROOT/WEB-INF/web.xml",
    require => Exec['ensure-owner'],
    notify  => Service['tomcat-jforum'],
  }

}
