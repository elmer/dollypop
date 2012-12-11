# database stack
class stack::database
  inherits stack {

  class {'postgres': stage => 'setup' }

  # create the databases
  $databases = split($::databases, ',')
  stack::database::create{$databases: ensure => present}
}
