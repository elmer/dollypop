# database stack
class stack::database {
  include stack

  class {'postgres':
    stage   => setup,
    require => Exec['refresh_apt_cache'],
  }

  # create the databases
  $databases = split($::databases, ',')
  stack::database::create{$databases: ensure => present}
}
