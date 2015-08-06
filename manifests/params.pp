class letschat::params {
  $http_enabled         = true
  $lc_bind_address      = '0.0.0.0'
  $http_port            = '5000'
  $ssl_enabled          = false
  $ssl_port             = '5001'
  $ssl_key              = 'key.pem'
  $ssl_cert             = 'certificate.pem'
  $xmpp_enabled         = false
  $xmpp_port            = '5222'
  $xmpp_domain          = 'example.com'
  $db_user              = 'lcadmin'
  $db_pass              = 'changeme'
  $db_host              = 'localhost'
  $db_name              = 'letschat'
  $db_port              = '27017'
  $mongo_bind_address   = '0.0.0.0'
  $lc_deploy_dir        = '/etc/letschat'
  $lc_user              = 'root'
  $lc_group             = 'root'
  $lc_user_home         = '/root'
  $cookie               = 'secretsauce'
  $authproviders        = 'local'
  $registration         = true
  $init_script_path     = $::osfamily ? {
    /Debian/  => $::lsbmajdistrelease ? {
      8       => '/etc/systemd/system/letschat.service',
      default => '/etc/init.d/letschat',
    },
    /RedHat/  => $::lsbmajdistrelease ? {
      7       => '/etc/systemd/system/letschat.service',
      default => '/etc/init.d/letschat',
    },
    default => '/etc/init.d/letschat',
  }
  $init_script_template = $init_script_path ? {
    '/etc/systemd/system/letschat.service' => 'letschat/letschat-systemd.erb',
    default                                => 'letschat/letschat.erb',
  }
  $init_script_mode = $init_script_path ? {
    '/etc/systemd/system/letschat.service' => '0644',
    default                                => '0755',
  }
  $use_system_python = false
  $ldap_auth_enabled = false
  $ldap_url = 'ldap://ldap.example.com'
  $ldap_tls_ca_cert = undef
  $ldap_bind_dn = 'uid=letschat,cn=sysusers,cn=accounts,dc=example,dc=com'
  $ldap_bind_credentials = 'Pa$$word123'
  $ldap_search_base = 'cn=users,cn=accounts,dc=example,dc=com'
  $ldap_search_scope = 'one'
  $ldap_search_filter = '(uid={{username}})'
  $ldap_field_mappings = {
    'uid'         => 'uid',
    'username'    => 'uid',
    'firstName'   => 'givenName',
    'lastName'    => 'sn',
    'displayName' => 'givenName',
    'email'       => 'mail',
  }
  $revision = 'master'
}
