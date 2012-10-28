# jruby stack
class stack::jruby {
  include stack

  class {'java':
    distribution => 'jdk',
    version      => 'installed',
    stage        => setup,
  }


}
