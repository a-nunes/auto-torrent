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
  $install_folder ="/usr/local/src"

  case $::osfamily {
    /^(Debian|Ubuntu)$/: {
      $rtorrentpackages = [
        'git', 'build-essential', 'automake', 'libtool', 'libcppunit-dev', 'libcurl4-openssl-dev', 'libsigc++-2.0-dev', 'libncurses5-dev', 'zlib1g-dev', 'libssl-dev', 'zip', 'unzip', 'rar', 'unrar', 'mediainfo', 'ffmpeg', 'apache2', 'libapache2-mod-php', 'php', 'php-curl', 'php-mbstring', 'php-geoip', 'python', 'python-openssl', 'python-lxml', 'python-certbot-apache', 'subversion', 'subversion-tools', 'libapache2-mod-svn'
      ]
    }
    default: {
      fail("${::osfamily} not yet supported")
    }
  }
  # update all system before start install (ubuntu 18.04)
  exec { 'apt-get update':
    path => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin']
  }

  exec { 'apt-get full-upgrade -y':
    path => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin']
  }
  # create a group media where all the app will be installed. 
  group {'media':
    ensure => 'present',
    system => true,
  }
  # create a user and add to media group
  user {'plex':
    ensure => 'present',
    groups => 'media',
  }
  
  

  # install rtorrent packages required for build (as of Ubuntu 14.04)
  package { $rtorrentpackages:
    ensure => installed;
  }
  file { $install_folder:
    ensure => present,
  }
  file { "${install_folder}/xmlrpc.sh":
    ensure  => present,
    mode    => '0555',
    source  => 'puppet:///modules/rtorrent/xmlrpc.sh',
  }
  exec { 'build-xmlrpc':
    command => "${install_folder}/xmlrpc.sh",
    timeout => 0,
    require => [File["${install_folder}/xmlrpc.sh"], Package[$rtorrentpackages]];
  }
  file { "${install_folder}/libtorrent.sh":
    ensure  => present,
    mode    => '0555',
    source  => 'puppet:///modules/rtorrent/libtorrent.sh',
  }
  exec { 'build-libtorrent':
    command => "${install_folder}/libtorrent.sh",
    timeout => 0,
    require => [File["${install_folder}/libtorrent.sh"], Package[$rtorrentpackages]];
  }
  file { "${install_folder}/rtorrent.sh":
    ensure  => present,
    mode    => '0555',
    source  => 'puppet:///modules/rtorrent/rtorrent.sh',
  }
  exec { 'build-rtorrent':
    command => "${install_folder}/rtorrent.sh",
    timeout => 0,
    require => [File["${install_folder}/rtorrent.sh"], Package[$rtorrentpackages]];
  }
  exec { 'ldconfig':
    path => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    require => [File["${install_folder}/rtorrent.sh"], Exec['build-rtorrent'], Package[$rtorrentpackages]];
  }
}
