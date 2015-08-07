class letschat::app (
  $deploy_dir            = $letschat::params::lc_deploy_dir,
  $revision              = $letschat::params::revision,
  $user                  = $letschat::params::lc_user,
  $group                 = $letschat::params::lc_group,
  $user_home             = $letschat::params::lc_user_home,
  $http_enabled          = $letschat::params::http_enabled,
  $lc_bind_address       = $letschat::params::lc_bind_address,
  $http_port             = $letschat::params::http_port,
  $ssl_enabled           = $letschat::params::ssl_enabled,
  $ssl_port              = $letschat::params::ssl_port,
  $ssl_key               = $letschat::params::ssl_key,
  $ssl_cert              = $letschat::params::ssl_cert,
  $xmpp_enabled          = $letschat::params::xmpp_enabled,
  $xmpp_port             = $letschat::params::xmpp_port,
  $xmpp_domain           = $letschat::params::xmpp_domain,
  $xmpp_tls_enabled      = $letschat::params::xmpp_tls_enabled,
  $xmpp_tls_key          = $letschat::params::xmpp_tls_key,
  $xmpp_tls_cert         = $letschat::params::xmpp_tls_cert,
  $xmpp_debug_handled    = $letschat::params::xmpp_debug_handled,
  $xmpp_debug_unhandled  = $letschat::params::xmpp_debug_unhandled,
  $dbuser                = $letschat::params::db_user,
  $dbpass                = $letschat::params::db_pass,
  $dbhost                = $letschat::params::db_host,
  $dbname                = $letschat::params::db_name,
  $dbport                = $letschat::params::db_port,
  $cookie                = $letschat::params::cookie,
  $authproviders         = $letschat::params::authproviders,
  $registration          = $letschat::params::registration,
  $init_script_path      = $letschat::params::init_script_path,
  $init_script_template  = $letschat::params::init_script_template,
  $init_script_mode      = $letschat::params::init_script_mode,
  $use_system_python     = $letschat::params::use_system_python,
  $ldap_auth_enabled     = $letschat::params::ldap_auth_enabled,
  $ldap_url              = $letschat::params::ldap_url,
  $ldap_tls_ca_cert      = $letschat::params::ldap_tls_ca_cert,
  $ldap_bind_dn          = $letschat::params::ldap_bind_dn,
  $ldap_bind_credentials = $letschat::params::ldap_bind_credentials,
  $ldap_search_base      = $letschat::params::ldap_search_base,
  $ldap_search_scope     = $letschat::params::ldap_search_scope,
  $ldap_search_filter    = $letschat::params::ldap_search_filter,
  $ldap_field_mappings   = $letschat::params::ldap_field_mappings,
  $rooms_private         = $letschat::params::rooms_private,
  $rooms_roster          = $letschat::params::rooms_roster,
  $rooms_expire          = $letschat::params::rooms_expire,
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
    $npm_install_command = 'npm install'
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
    user     => $user,
    source   => 'https://github.com/sdelements/lets-chat.git',
    revision => $revision,
    require  => Class['nodejs'],
  }

  file { "${deploy_dir}/settings.yml":
    ensure  => 'file',
    owner   => $user,
    group   => $group,
    mode    => '0640',
    content => template('letschat/settings.yml.erb'),
    require => Vcsrepo[$deploy_dir],
  }
  file { $init_script_path:
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => $init_script_mode,
    content => template($init_script_template),
  }
  if $init_script_path == '/etc/systemd/system/letschat.service' {
    # run systemctl daemon-reload on unit changes
    exec { 'systemctl daemon-reload':
      refreshonly => true,
      subscribe   => File[$init_script_path],
      path        => ['/bin','/usr/bin', '/usr/sbin'],
    }
  }
  service { 'letschat':
    ensure    => 'running',
    enable    => true,
    subscribe => File["${deploy_dir}/settings.yml"],
    require   => File[$init_script_path],
  }
  exec { 'touch install.lock':
    cwd    => $deploy_dir,
    user   => $user,
    onlyif => 'service letschat status',
    unless => 'test -f install.lock',
    path   => ['/bin','/usr/bin', '/usr/sbin'],
  } ->
  exec { $npm_install_command:
    cwd     => $deploy_dir,
    user    => $user,
    unless  => 'test -f install.lock',
    timeout => '0',
    environment => "HOME=${user_home}",
    path    => '/usr/bin',
    require => Vcsrepo[$deploy_dir],
  }

  if $ldap_auth_enabled {
    nodejs::npm { 'lets-chat-ldap':
      target          => $deploy_dir,
      install_options => [ '--save' ],
      require         => Exec[$npm_install_command],
    }
  }
}
