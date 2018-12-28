# == Class: rtorrent::rtorrent_build
#
# Builds rtorrent from source due to most distros do not compile rtorrent
# with xmlrpc-c. rtorrent is also out of date in some distros.
#
# Process: All required development packages and compilers are installed first.
# The libtorrent repo is cloned from github and compiled. Then the rtorrent repo
# is cloned from github and compiled. See files/rtorrent-build.sh (after this class
# is executed it is in /home/rtorrent/rtorrent-build.sh) for details
#
# == Parameters:
#
# There are no parameters for this class
#
class rtorrent::rtorrent_build {

  case $::osfamily {
    'RedHat', 'CentOS': {
      # only CentOS/RedHat 7
      if $::lsbmajdistrelease == '7' {
        package {
          'libidn-devel':
            ensure => installed;
          'libcurl-openssl':
            ensure   => installed,
            provider => 'rpm',
            source   => 'http://ftp.riken.jp/Linux/cern/centos/7/cern/x86_64/Packages/libcurl-openssl-7.51.0-2.1.el7.cern.x86_64.rpm';
          'libcurl-openssl-devel':
            ensure   => installed,
            provider => 'rpm',
            source   => 'http://ftp.riken.jp/Linux/cern/centos/7/cern/x86_64/Packages/libcurl-openssl-devel-7.51.0-2.1.el7.cern.x86_64.rpm',
            require  => Package['libidn-devel','libcurl-openssl'];
        }
        $rtorrentpackages = [
          # Build deps
          'git', 'gcc-c++', 'automake', 'make', 'libtorrent', 'libtorrent-devel',
          'pkgconfig', #stops ./configure from finding openssl if missing
          # libraries for libtorrent
          'xmlrpc-c-devel', 'libtool', 'cppunit-devel', 'zlib-devel', 'openssl-devel',
          #'libsigc++-2.0-dev', #doesn't stop ./configure, guess it's not needed?
          # libraries for rtorrent
          'ncurses-devel',
        ]
      } else {
        fail("${::osfamily} ${::lsbmajdistrelease} not yet supported")
      }
    }
    /^(Debian|Ubuntu)$/: {
      $rtorrentpackages = [
        # Build deps
        'git', 'g++', 'automake', 'make', 'pkg-config',
        # libraries for libtorrent
        'libxmlrpc-c++8-dev', 'libtool', 'libcppunit-dev', 'zlib1g-dev', 'libssl-dev',
        #'libsigc++-2.0-dev', #doesn't stop ./configure, guess it's not needed?
        # libraries for rtorrent
        'libncurses5-dev', 'libcurl4-openssl-dev'
      ]
    }
    default: {
      fail("${::osfamily} not yet supported")
    }
  }

  # install rtorrent packages required for build (as of Ubuntu 14.04)
  package { $rtorrentpackages:
    ensure => installed;
  }
  file { '/home/rtorrent/rtorrent-build.sh':
    ensure  => present,
    owner   => 'rtorrent',
    group   => 'rtorrent',
    mode    => '0555',
    source  => 'puppet:///modules/rtorrent/rtorrent-build.sh',
    require => User['rtorrent'];
  }
  exec { 'build-rtorrent':
    command => '/home/rtorrent/rtorrent-build.sh',
    creates => '/usr/local/bin/rtorrent',
    timeout => 0,
    require => [File['/home/rtorrent/rtorrent-build.sh'], Package[$rtorrentpackages]];
  }
}
