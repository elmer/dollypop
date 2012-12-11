# jforum app
class stack::apps::jforum(
  $appserver=undef
) {

  class { 'java':
    distribution => 'jdk',
    version      => 'installed',
    stage        => 'setup',
  }


  case $appserver {
    'tomcat': {
      class { 'stack::apps::jforum::tomcat':
        stage   => 'setup',
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
