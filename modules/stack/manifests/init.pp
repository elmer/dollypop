# main stack module
class stack {
  include stdlib

  stage { 'prep': before => Stage['setup'] }

  class {'stack::setup': stage => prep }
  ->
  class {'apt::unattended-upgrades': stage => prep }

}
