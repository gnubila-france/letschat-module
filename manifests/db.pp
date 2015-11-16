class letschat::db (
  $user                = $letschat::params::db_user,
  $pass                = $letschat::params::db_pass,
  $bind_ip             = $letschat::params::mongo_bind_address,
  $database_name       = $letschat::params::db_name,
  $database_port       = $letschat::params::db_port,
  $manage_package_repo = $letschat::params::manage_package_repo,
) inherits letschat::params {

  class { '::mongodb::globals':
    manage_package_repo => $manage_package_repo,
    bind_ip             => $bind_ip,
  }->

  class { '::mongodb::server':
    port => $database_port,
  }

  class { '::mongodb::client': }

  mongodb::db { $database_name:
    user     => $user,
    password => $pass,
  }
}
