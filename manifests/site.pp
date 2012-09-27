case $::node {
  'database': {
    include stack::database
  }

  'lamp': {
    case $::app {
      'drupal': {
        include stack::apps::drupal
      }
      'wordpress': {
        include stack::apps::wordpress
      }
      default : {
        fail("Invalid '${::spp}' app for '${::node}' stack")
      }
    }
  }

  'rails': {
    case $::app {
      'redmine': {
        include stack::apps::redmine
      }
      default : {
        fail("Invalid '${::spp}' app for '${::node}' stack")
      }

    }
  }

  'tomcat': {
    case $::app {
      'jforum': {
        class { 'stack::apps::jforum':
          appserver => 'tomcat',
        }
      }
      'test': {
        include stack::apps::tets
      }
      default : {
        fail("Invalid '${::app}' for the '${::node}' stack")
      }
    }
  }

  'jboss': {
    case $::app {
      'jforum': {
        class { 'stack::apps::jforum':
          appserver => 'jboss',
        }
      }
      'test': {
        include stack::apps::tets
      }
      default : {
        fail("Invalid '${::app}' for the '${::node}' stack")
      }
    }
  }

  'java': {
    fail("Unsupported stack '${::node}'")
  }
  default : {
    fail("I do not know how to configure system of type ${::node}...")
  }
}

node default {
}
