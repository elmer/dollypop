# jruby stack
class stack::jruby {

  class { 'java':
    distribution => 'jdk',
    version      => 'installed',
    stage        => 'setup',
  }

}
