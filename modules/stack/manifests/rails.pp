# rails stack
class stack::rails {
  include stack

  class { 'stack::ruby':
    stage => setup
  }
}
