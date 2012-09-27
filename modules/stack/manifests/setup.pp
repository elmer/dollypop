class stack::setup {
  notify{"Setting up stack...":}
  ->
  exec {'refresh_apt_cache':
    command     => "/usr/bin/apt-get -q update",
    #command     => "/bin/true || /usr/bin/apt-get -q update",
  }
}
