# jforum on tomcat
class stack::apps::jforum_tomcat {

  class { 'tomcat':
    stage   => 'setup',
    require => Class['java'],
  }

  class { 'stack::apps::jforum_tomcat_install':
    stage => 'setup_infra',
  }

}
