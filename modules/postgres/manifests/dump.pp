define postgres::dump($ensure, $owner = undef, $path = undef) {
  case $ensure {
    present: {
      exec { "Restore $name from $path":
        command => "/usr/bin/psql $name < $path",
        user    => 'postgres',
        onlyif  => "/usr/bin/psql $name -c '\\d' | grep 'No relations found.'"
      }
    }

    absent: {
      # empty db?
      notify{'I cant empty your db now!': }
    }

    default: {
      fail "Invalid 'ensure' value '$ensure' for postgres::dump"
    }
  }
}
