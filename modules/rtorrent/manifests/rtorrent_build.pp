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
  #
  # case $::osfamily {
  #   /^(Debian|Ubuntu)$/: {
  #     $rtorrentpackages = [
  #       'git', 'build-essential', 'automake', 'libtool', 'libcppunit-dev', 'libcurl4-openssl-dev', 'libsigc++-2.0-dev', 'libncurses5-dev', 'zlib1g-dev', 'libssl-dev', 'zip', 'unzip', 'rar', 'unrar', 'mediainfo', 'ffmpeg', 'apache2', 'libapache2-mod-php', 'php', 'php-curl', 'php-mbstring', 'php-geoip', 'python', 'python-openssl', 'python-lxml', 'python-certbot-apache', 'subversion', 'subversion-tools', 'libapache2-mod-svn'
  #     ]
  #   }
  #   default: {
  #     fail("${::osfamily} not yet supported")
  #   }
  # }
  # # update all system before start install (ubuntu 18.04)
  # exec { 'apt-get update':
  #   path => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin']
  # }
  #
  # exec { 'apt-get full-upgrade -y':
  #   path => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin']
  # }
  # # create a group media where all the app will be installed.
  # group {'media':
  #   ensure => 'present',
  #   system => true,
  # }
  # # create a user and add to media group
  # user {'plex':
  #   ensure => 'present',
  #   groups => 'media',
  # }
  # # install rtorrent packages required for build (as of Ubuntu 14.04)
  # package { $rtorrentpackages:
  #   ensure => installed;
  # }
  #
  # # install and compile xmlrpc, libtorrent and rtorrent.
  # file { $install_folder:
  #   ensure => 'directory',
  # }
  #
  # file { "${install_folder}/xmlrpc.sh":
  #   ensure  => present,
  #   mode    => '0555',
  #   source  => 'puppet:///modules/rtorrent/xmlrpc.sh',
  # }
  # exec { 'build-xmlrpc':
  #   command => "${install_folder}/xmlrpc.sh",
  #   timeout => 0,
  #   require => [File["${install_folder}/xmlrpc.sh"], Package[$rtorrentpackages]];
  # }
  # file { "${install_folder}/libtorrent.sh":
  #   ensure  => present,
  #   mode    => '0555',
  #   source  => 'puppet:///modules/rtorrent/libtorrent.sh',
  # }
  # exec { 'build-libtorrent':
  #   command => "${install_folder}/libtorrent.sh",
  #   timeout => 0,
  #   require => [File["${install_folder}/libtorrent.sh"], Package[$rtorrentpackages]];
  # }
  # file { "${install_folder}/rtorrent.sh":
  #   ensure  => present,
  #   mode    => '0555',
  #   source  => 'puppet:///modules/rtorrent/rtorrent.sh',
  # }
  # exec { 'build-rtorrent':
  #   command => "${install_folder}/rtorrent.sh",
  #   timeout => 0,
  #   require => [File["${install_folder}/rtorrent.sh"], Package[$rtorrentpackages]];
  # }
  #
  # file { '/usr/bin/rtorrent':
  #   ensure => 'link',
  #   target => '/usr/local/bin/rtorrent',
  # }
  # exec { 'ldconfig':
  #   path => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin'],
  #   require => [File["${install_folder}/rtorrent.sh"], File['/usr/local/bin/rtorrent'], Exec['build-rtorrent'], Package[$rtorrentpackages]];
  # }
  # #ensure that home for user rtorrent exists
  # $home_foder = ['/var/lib', '/var/lib/rtorrent', '/var/lib/rtorrent/session', '/etc/rtorrent']
  #
  # file { $home_foder:
  #   ensure => 'directory',
  # }
  # #create user rtorrent and define folder to it
  # group {'rtorrent':
  #   ensure => present,
  #   system => true,
  # }
  # user {'rtorrent':
  #   ensure => present,
  #   system => true,
  #   groups => ['rtorrent', 'media'],
  #   home => '/var/lib/rtorrent',
  #   require => [Group['rtorrent']],
  # }
  # # create all folders need to use it correctly
  # file { "${install_folder}/mkdir.sh":
  #   ensure  => present,
  #   mode    => '0555',
  #   source  => 'puppet:///modules/rtorrent/mkdir.sh',
  # }
  # exec { 'build-mkdir':
  #   command => "${install_folder}/mkdir.sh",
  #   timeout => 0,
  #   require => [File["${install_folder}/mkdir.sh"], Package[$rtorrentpackages]];
  # }

  # create configs files through ultimate-torrent-setup
  file { "${install_folder}/ultimate-torrent-setup.sh":
    ensure  => present,
    mode    => '0555',
    source  => 'puppet:///modules/rtorrent/ultimate-torrent-setup.sh',
  }
  exec { 'build-ultimate-torrent-setup':
    command => "${install_folder}/ultimate-torrent-setup.sh",
    timeout => 0,
    # require => [File["${install_folder}/ultimate-torrent-setup.sh"], Package[$rtorrentpackages]];
  }

  file {'/etc/rtorrent/rtorrent.rc':
    ensure  => present,
    content => template('rtorrent/rtorrent.rc.erb')
  }

  file { "${install_folder}/change_folders.sh":
    ensure  => present,
    mode    => '0555',
    source  => 'puppet:///modules/rtorrent/change_folders.sh',
  }
  exec { 'build-change_folders':
    command => "${install_folder}/change_folders.sh",
    timeout => 0,
    # require => [File["${install_folder}/change_folders.sh"], Package[$rtorrentpackages]];
  }
  exec { 'update-rutorrent':
    command => "/usr/local/bin/update-rutorrent",
    timeout => 0,
    # require => [File["${install_folder}/change_folders.sh"], Package[$rtorrentpackages]];
  }



  # service { 'rtorrent':
  #   ensure     => running,
  #   hasstatus  => true,
  #   hasrestart => true,
  #   enable     => true,
  #   require    => Class['rtorrent::rtorrent_build'];
  # }
}
