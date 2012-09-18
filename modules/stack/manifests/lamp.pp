class stack::lamp {
  include stack

  class {'apache': stage => setup }
}
