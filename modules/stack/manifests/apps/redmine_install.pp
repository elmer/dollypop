class stack::apps::redmine_install($path, $owner) {

  $redmine_file = "redmine-2.1.0.tar.gz"
  $redmine_source = "http://rubyforge.org/frs/download.php/76448/redmine-2.1.0.tar.gz"

  Exec { path => "/usr/local/rvm/bin:/usr/bin:/bin:/usr/sbin:/sbin" }

  $packages = [ "libpq-dev", "librmagick-ruby", "libmagickcore-dev",
      "imagemagick", "libmagickwand-dev", "libopenssl-ruby1.8",
      "subversion", "git" ]

  package { $packages:
    ensure => installed,
  }

  rvm::define::gem { 'unicorn':
    ensure       => present,
    ruby_version => "ruby-1.9.2",
    gemset       => "redmine",
  }

  file { "${path}/download":
    ensure => directory,
    owner  => $owner,
    group  => $owner,
  }

  exec {'redmine_source':
    command => "wget -O ${path}/download/${redmine_file} ${redmine_source}",
    creates => "${path}/download/${redmine_file}",
    require => File["${path}/download"],
  }

  exec {"extract_source":
    command => "tar xzf ${path}/download/${redmine_file}",
    cwd     => $path,
    creates => "${path}/redmine-2.1.0",
    require => Exec['redmine_source'],
  }

  exec {'ensure_owner':
    command => "chown -R ${owner}:${owner} ${path}/redmine-2.1.0",
    require => Exec['extract_source'],
  }

  exec {'bundle_wrapper':
    command => "rvm wrapper 1.9.2@redmine redmine bundle",
    cwd     => $path,
    user    => $owner,
    creates => "/usr/local/rvm/bin/redmine_bundle",
  }

  $rvmsource="source /usr/local/rvm/scripts/rvm; rvm use 1.9.2@redmine"

  exec {'bundle_redmine':
    user        => $owner,
    cwd         => "${path}/redmine-2.1.0",
    command     => "bash -c '${rvmsource}; redmine_bundle install --without development test mysql sqlite'",
    environment => "rvm_path=/usr/local/rvm",
    require     => [ Exec['bundle_wrapper'], Exec['ensure_owner'] ],
  }

  $redmine_database = $::database_name
  $redmine_username = $::database_user
  $redmine_password = $::database_password
  $redmine_dbhost = $::database_host

  file {"${path}/redmine-2.1.0/config/database.yml":
    ensure  => present,
    content => template("stack/redmine/database.yml.erb"),
    owner   => $owner,
    group   => $owner,
    require => Exec['bundle_redmine'],
  }

  exec {"redmine_rake_generate_token":
    user        => $owner,
    cwd         => "${path}/redmine-2.1.0",
    command     => "bash -c '${rvmsource}; rake generate_secret_token'",
    environment => "rvm_path=/usr/local/rvm",
    require     => File["${path}/redmine-2.1.0/config/database.yml"],
  }

  exec {"redmine_rake_migrate":
    user        => $owner,
    cwd         => "${path}/redmine-2.1.0",
    command     => "bash -c '${rvmsource}; RAILS_ENV=production rake db:migrate'",
    environment => "rvm_path=/usr/local/rvm",
    require     => Exec['redmine_rake_generate_token'],
  }

  exec {"redmine_load_default_data":
    user        => $owner,
    cwd         => "${path}/redmine-2.1.0",
    command     => "bash -c '${rvmsource}; RAILS_ENV=production REDMINE_LANG=en rake redmine:load_default_data'",
    environment => "rvm_path=/usr/local/rvm",
    require     => Exec['redmine_rake_migrate'],
  }

  file {"redmine_files":
    path   => "${path}/redmine-2.1.0/files",
    ensure => directory,
    owner  => $owner,
    group  => $owner,
  }

  file { "redmine_log":
    path   => "${path}/redmine-2.1.0/log",
    ensure => directory,
    owner  => $owner,
    group  => $owner,
  }

  file {"redmine_tmp":
    path   => "${path}/redmine-2.1.0/tmp",
    ensure => directory,
    owner  => $owner,
    group  => $owner,
  }

  file {"redmine_plugin_assets":
    path   => "${path}/redmine-2.1.0/public/plugin_assets",
    ensure => directory,
    owner  => $owner,
    group  => $owner,
  }

  # init
  file { '/etc/init/redmine.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template("stack/redmine/redmine_init.erb"),
    require => [ File["redmine_files"], File["redmine_log"],
                 File["redmine_tmp"], File["redmine_plugin_assets"],
                 Rvm::Define::Gem['unicorn'],
                 Exec["redmine_load_default_data"]
               ],
  }

  file { "/etc/init.d/redmine":
    ensure  => link,
    target  => "/etc/init.d/plymouth-upstart-bridge",
    require  => File["/etc/init/redmine.conf"],
  }

  service { "redmine":
    ensure     => running,
    hasrestart => false,
    require    => File["/etc/init.d/redmine"],
  }


}
