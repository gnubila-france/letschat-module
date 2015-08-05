class letschat::app (
  $deploy_dir           = $letschat::params::lc_deploy_dir,
  $http_enabled         = $letschat::params::http_enabled,
  $lc_bind_address      = $letschat::params::lc_bind_address,
  $http_port            = $letschat::params::http_port,
  $ssl_enabled          = $letschat::params::ssl_enabled,
  $ssl_port             = $letschat::params::ssl_port,
  $ssl_key              = $letschat::params::ssl_key,
  $ssl_cert             = $letschat::params::ssl_cert,
  $xmpp_enabled         = $letschat::params::xmpp_enabled,
  $xmpp_port            = $letschat::params::xmpp_port,
  $xmpp_domain          = $letschat::params::xmpp_domain,
  $dbuser               = $letschat::params::db_user,
  $dbpass               = $letschat::params::db_pass,
  $dbhost               = $letschat::params::db_host,
  $dbname               = $letschat::params::db_name,
  $dbport               = $letschat::params::db_port,
  $cookie               = $letschat::params::cookie,
  $authproviders        = $letschat::params::authproviders,
  $registration         = $letschat::params::registration,
  $init_script_path     = $letschat::params::init_script_path,
  $init_script_template = $letschat::params::init_script_template,
  $use_system_python    = $letschat::params::use_system_python,
) inherits letschat::params {

  $dependencies = ['gcc-c++', 'make', 'git', 'libicu-devel']

  package { $dependencies:
    ensure => present,
    before => Class['nodejs'],
  }

  if $use_system_python {
    package { 'python':
      ensure => 'installed',
    }
    $nodejs_python_dependency = Package['python']
    $npm_install_command = ''
  } else {
    include '::letschat::python'
    $nodejs_python_dependency = Class['::letschat::python']
    $npm_install_command = 'npm install --python=/usr/bin/python2.7'
  }

  class { 'nodejs':
    require => $nodejs_python_dependency,
  }

  vcsrepo { $deploy_dir:
    ensure   => present,
    provider => git,
    source   => 'https://github.com/sdelements/lets-chat.git',
    require  => Class['nodejs'],
  }

  file { "${deploy_dir}/settings.yml":
    ensure  => present,
    content => template('letschat/settings.yml.erb'),
    require => Vcsrepo[$deploy_dir],
  }
  file { $init_script_path:
    ensure  => present,
    content => template($init_script_template),
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
  }
  service { 'letschat':
    ensure    => 'running',
    enable    => true,
    subscribe => File["${deploy_dir}/settings.yml"],
    require   => File[$init_script_path],
  }
  exec { 'touch install.lock':
    cwd    => $deploy_dir,
    onlyif => 'service letschat status',
    unless => 'test -f install.lock',
    path   => ['/bin','/usr/bin', '/usr/sbin'],
  } ->
  exec { $npm_install_command:
    cwd     => $deploy_dir,
    path    => '/usr/bin',
    unless  => 'test -f install.lock',
    require => Vcsrepo[$deploy_dir],
    timeout => '0',
  }
}
