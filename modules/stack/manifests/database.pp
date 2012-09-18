class stack::database {
  include stack

  class {"postgres":
    stage  => setup,
    require => Exec['refresh_apt_cache'],
  }


  define create($ensure) {

    $database = $name
    $owner = getvar("::database_${database}_user")
    $password = getvar("::database_${database}_password")

    if $owner == undef {
      fail("Missing DB:user parameters")
    }

    if $password == undef {
      fail("Missing DB:password parameters")
    }

    postgres::role{ $owner:
      ensure   => present,
      password => $password,
    }
    ->
    postgres::database {$database:
      ensure  => present,
      owner   => $owner,
    }
  }

  # create the databases
  $databases = split($::databases, ',')
  stack::database::create{$databases: ensure => present}
}
