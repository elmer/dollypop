# create database
define stack::database::create($ensure=present) {

  $database = $name
  $owner = getvar("::database_${database}_user")
  $password = getvar("::database_${database}_password")
  $dump_file = getvar("::database_${database}_dump")

  if $owner == undef {
    fail('Missing DB:user parameters')
  }

  if $password == undef {
    fail('Missing DB:password parameters')
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
  # restore from pg_dump
  if $dump_file {
    file { "/tmp/${dump_file}.sql":
      ensure  => present,
      source  => "puppet:///modules/stack/databases/${dump_file}.sql",
      owner   => 'postgres',
      require => Postgres::Database[$database],
    }

    postgres::dump {$database:
      ensure  => present,
      owner   => $owner,
      path    => "/tmp/${dump_file}.sql",
      require => File["/tmp/${dump_file}.sql"],
    }

  }
}
