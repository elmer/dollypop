# drupal dependencies
class stack::apps::drupal::dependencies {

  $packages = [ 'libssh2-php' ]

  package{$packages:
    ensure  => installed,
  }
}
