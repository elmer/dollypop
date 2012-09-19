class stack::apps::drupal_dependencies {

  $packages = [ "php5-gd", "libssh2-php", "php5-pgsql" ]

  package{$packages:
    ensure => installed,
  }
}
