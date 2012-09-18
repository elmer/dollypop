class stack {
  include stdlib

  class {"stack::setup": stage => setup }
  ->
  class {'apt::unattended-upgrades': stage => setup }

}
