class stack::apps::jforum($appserver) {
  include stack

  class {'java':
    distribution => 'jdk',
    version      => 'installed',
    stage        => 'setup',
  }

  case $appserver {
    'tomcat': {
      class { 'stack::apps::jforum_tomcat':
        stage   => 'setup',
        }
     }
     'jboss': {
       class { 'stack::apps::jforum_jboss':
         stage   => 'setup',
       }
     }
     default : {
       fail("jforum cannot be installed on this appserver: '${appserver}'")
     }
  }



}
