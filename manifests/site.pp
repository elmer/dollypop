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
      default: {
        fail("Invalid app stack name")
      }
    }
  }
  default: {
    fail("I do not know how to configure system of type ${::node}...")
  }
}

node default {
}
