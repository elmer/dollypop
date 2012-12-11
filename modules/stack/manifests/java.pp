# java based stack
class stack::java
  inherits stack {

  class { 'java':
    distribution => 'jdk',
    version      => 'installed',
    stage        => 'setup',
  }

}
