# drupal dependencies
class stack::apps::drupal_dependencies {

  $packages = [ 'libssh2-php' ]

  package{$packages:
    ensure  => installed,
  }
}
