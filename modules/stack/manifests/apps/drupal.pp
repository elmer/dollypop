# drupal app
class stack::apps::drupal {

  include stack::lamp

  $site_name = $::site_name
  $vhost_name = $::ipaddress
  $doc_root = '/var/www/drupal'

  apache::vhost {$site_name:
    priority           => '10',
    vhost_name         => '*', #$vhost_name,
    port               => '80',
    docroot            => $doc_root,
    serveraliases      => [ $site_name ],
    configure_firewall => false,
    require            => Package['httpd'],
  }

  class {'stack::apps::drupal::dependencies':
    stage => setup,
  }

  class {'stack::apps::drupal::install':
    doc_root => $doc_root,
    stage    => deploy,
  }

}
