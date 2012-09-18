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
      'jenkins': {
        include stack::apps::jenkins
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

notify{"databases":
  message => "databases = $::databases",
}


node default {
}
