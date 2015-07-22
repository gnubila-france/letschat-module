class letschat::db (
  $user           = $letschat::params::dbuser,
  $pass           = $letschat::params::dbpass,
  $bind_ip        = $letschat::params::mongo_bind_address,
  $database_name  = $letschat::params::dbname,
  $database_port  = $letschat::params::dbport,
) inherits letschat::params {

  class { '::mongodb::globals':
    manage_package_repo => true,
    bind_ip             => $bind_ip,
  }->
  
  class { '::mongodb::server':}

  class { '::mongodb::client': }
  
  mongodb::db { $database_name:
    user          => $user,
    password      => $pass,
  }
}
