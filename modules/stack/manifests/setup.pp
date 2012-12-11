# stack setup
class stack::setup {
  notify{ 'stack_setup_notify_start':
    message => 'Setting up stack...',
    before  => Exec['refresh_apt_cache'],
  }

  if $::http_proxy {
    file { '/etc/apt/apt.conf.d/60proxy':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0444',
      content => "Acquire::http::Proxy \"http://${::http_proxy}\";",
      before  => Exec['refresh_apt_cache'],
    }
  }

  exec {'refresh_apt_cache':
    environment => 'DEBIAN_FRONTEND=noninteractive',
    command     => '/usr/bin/apt-get --option Dpkg::Options::=--force-confold --assume-yes update',
    #command    => "/bin/true || /usr/bin/apt-get -q update",
  }
}
