class letschat::python {
  $packagelist = ['zlib-devel','bzip2-devel','openssl-devel','ncurses-devel','sqlite-devel','readline-devel','tk-devel']
  exec { 'yum groupinstall "Development tools" | touch /etc/group.lock':
    cwd     => '/etc',
    path    => ['/usr/bin','/bin'],
    creates => '/etc/group.lock',
  }
  package { $packagelist:
    ensure => present,
  }
  exec { 'wget http://python.org/ftp/python/2.7.3/Python-2.7.3.tar.bz2':
    cwd     => '/etc',
    path    => '/usr/bin',
    creates => '/etc/Python-2.7.3.tar.bz2',
    timeout => '0',
  } ->
  exec { 'tar xf Python-2.7.3.tar.bz2':
    cwd     => '/etc',
    path    => ['/bin','/usr/bin'],
    unless  => '/usr/bin/test -d /etc/Python-2.7.3',
    timeout => '0',
  } ->
  exec { 'bash configure --prefix=/usr':
    cwd     => '/etc/Python-2.7.3',
    path    => ['/bin','/usr/bin'],
    unless  => 'test -f /usr/bin/python2.7',
    timeout => '0',
  } ->
  exec { '/usr/bin/make && /usr/bin/make altinstall':
    cwd     => '/etc/Python-2.7.3',
    path    => ['/bin','/usr/bin'],
    unless  => 'test -f /usr/bin/python2.7',
    timeout => '0',
  }
}
