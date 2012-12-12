# jforum app
class stack::apps::jforum(
  $appserver=undef
) {
  include stack

  class { 'java':
    distribution => 'jdk',
    version      => 'installed',
    stage        => 'setup',
  }

  case $appserver {
    'tomcat': {
      class { 'tomcat':
        stage   => 'setup',
        require => Class['java'],
      }
      class { 'stack::apps::jforum::tomcat::install':
        stage => 'setup_infra',
      }
    }
    'jboss': {
      class { 'stack::apps::jforum::jboss':
        stage   => 'setup',
      }
    }
    default : {
      fail("jforum cannot be installed on this appserver: '${appserver}'")
    }
  }

}
