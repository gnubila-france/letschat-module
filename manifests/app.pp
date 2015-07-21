define letschat::app (
  $deploy_dir = $letschat::params::lc_deploy_dir
   

  $dependencies = ["gcc-c++", "make", "git", "libicu-devel"]
  
  class { 'nodejs': }
  
  class { 'python': }
  
  package { $dependencies:
    ensure => present,
    before => Class['nodejs'],
  } 

  vcsrepo { $deloy_dir:
    ensure   => present,
    provider => git,
    source   => 'https://github.com/sdelements/lets-chat.git',
  }
}
