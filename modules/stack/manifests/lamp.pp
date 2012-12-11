# lamp stack
class stack::lamp
  inherits stack {

  include apache, apache::mod::php

  $common_packages = [ 'php5-gd', 'php5-pgsql' ]

  package{$common_packages:
    ensure  => installed,
    require => Class['apache'],
  }
}
