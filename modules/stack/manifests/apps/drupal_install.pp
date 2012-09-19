class stack::apps::drupal_install($doc_root) {

  $drupal = "drupal-7.15"
  $drupal_source = "${drupal}.tar.gz"

  $www_user = "www-data"
  $www_group = "www-data"

  Exec { path => "/usr/bin:/bin:/usr/sbin:/sbin" }

  exec {'drupal_source':
    command => "wget -O /opt/${drupal_source} http://ftp.drupal.org/files/projects/${drupal_source}",
    creates => "/opt/${drupal_source}",
  }

  exec {'extract_source':
    command => "tar xzf /opt/${drupal_source}",
    cwd     => "/opt",
    creates => "/opt/${drupal}/index.php",
    require => Exec['drupal_source'],
  }

  exec {'move_to_docroot':
    command => "mv /opt/${drupal}/* ${doc_root}/",
    creates => "${doc_root}/index.php",
    require => Exec['extract_source'],
  }


  $drupal_database = $::database_name
  $drupal_username = $::database_user
  $drupal_password = $::database_password
  $drupal_host = $::database_host

  file {"${doc_root}/sites/default/settings.php":
    ensure  => present,
    owner   => $www_user,
    group   => $www_user,
    content => template("stack/drupal/settings.php.erb"),
    require => Exec['move_to_docroot'],
  }

  exec {'chown_to_apache':
    command     => "chown -R ${www_user}:${www_group} ${doc_root}",
    require     => Exec['move_to_docroot'],
  }

}
