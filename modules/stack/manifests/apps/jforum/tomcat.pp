# jforum on tomcat
class stack::apps::jforum::tomcat {

  class { 'tomcat':
    stage   => 'setup',
    require => Class['java'],
  }

  class { 'stack::apps::jforum::tomcat::install':
    stage => 'setup_infra',
  }

}
