class letschat {
  $dependencies = ["gcc-c++", "make", "git", "libicu-devel"]
  class { 'nodejs': }
  class { 'python': }
  package { $dependencies:
    ensure => present,
    before => Class['nodejs'],
  } #had to do this because of dependency issues with gyp

  vcsrepo { '/etc/letschat':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/sdelements/lets-chat.git',
  } 
}
