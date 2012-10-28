# ruby stack
class stack::ruby {
  include stack

  class { 'rvm': stage => setup, }

  rvm::define::version { 'ruby-1.9.2':
    ensure => present,
  }


}
