class letschat::app (
  $deploy_dir      = $letschat::params::lc_deploy_dir,
  $http_enabled    = $letschat::params::http_enabled,
  $lc_bind_address = $letschat::params::lc_bind_address,
  $http_port       = $letschat::params::http_port,
  $ssl_enabled     = $letschat::params::ssl_enabled,
  $ssl_port        = $letschat::params::ssl_port,
  $ssl_key         = $letschat::params::ssl_key,
  $ssl_cert        = $letschat::params::ssl_cert,
  $xmpp_enabled    = $letschat::params::xmpp_enabled,
  $xmpp_port       = $letschat::params::xmpp_port,
  $xmpp_domain     = $letschat::params::xmpp_domain,
  $dbuser          = $letschat::params::db_user,
  $dbpass          = $letschat::params::db_pass,
  $dbhost          = $letschat::params::db_host,
  $dbname          = $letschat::params::db_name,
  $dbport          = $letschat::params::db_port,
  $cookie          = $letschat::params::cookie,
  $authproviders   = $letschat::params::authproviders,
  $registration    = $letschat::params::registration,
) inherits letschat::params {

  $dependencies = ["gcc-c++", "make", "git", "libicu-devel"]
  
  class { 'nodejs':
    require => Class['python'],  
  }
  
  class { 'python': }
  
  package { $dependencies:
    ensure => present,
    before => Class['nodejs'],
  } 

  vcsrepo { $deploy_dir:
    ensure   => present,
    provider => git,
    source   => 'https://github.com/sdelements/lets-chat.git',
    require  => Class['nodejs'],
  }
  
  file { "$deploy_dir/settings.yml":
    ensure  => present,
    content => template("letschat/settings.yml.erb"),
  }
  file { "/etc/init.d/letschat":
    ensure  => present,
    content => template("letschat/letschat.erb"),
    mode    => "0755",
    owner   => "root",
    group   => "root",
  }
  service { "letschat":
    ensure    => 'running',
    enable    => 'true',
    subscribe => File["$deploy_dir/settings.yml"],
    require   => File["/etc/init.d/letschat"],
  }
  exec { "touch install.lock":
    cwd    => "$deploy_dir",
    onlyif => "/etc/init.d/letschat status",
    unless => "test -f install.lock",
    path   => ["/bin","/usr/bin"],
  } ->  
  exec { "npm install":
    cwd     => "$deploy_dir",
    path    => "/usr/bin",
    unless  => "test -f install.lock",
    require => Vcsrepo[$deploy_dir],
  }
}
