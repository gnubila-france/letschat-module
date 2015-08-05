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
  $cookie               = 'secretsauce'
  $authproviders        = 'local'
  $registration         = true
  $init_script_path     = '/etc/systemd/system/letschat.service'
  $init_script_template = $::osfamily ? {
    /Debian/  = > $::lsbmajdistrelease ? {
      8       = > 'letschat/letschat-systemd.erb',
      default = > 'letschat/letschat.erb',
    },
    /RedHat/  => $::lsbmajdistrelease ? {
      7       => 'letschat/letschat-systemd.erb',
      default => 'letschat/letschat.erb',
    },
    default => 'letschat/letschat.erb',
  }
}
