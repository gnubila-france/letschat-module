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
}
