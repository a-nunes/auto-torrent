#
# ==== Class: rtorrent::rutorrent
#
# Downloads rtorrent
#
# ==== Parameters:
#
# [*rutorrent_wwwdir*]
#    The full directory path that rutorrent will be installed, see init::rutorrent_dir
#
class rtorrent::rutorrent(
  $rutorrent_fullwwwdir
) {
  # Execute rutorrent build
  file { '/home/rtorrent/rutorrent-build.sh':
    ensure  => present,
    owner   => 'rtorrent',
    group   => 'rtorrent',
    mode    => '0555',
    source  => 'puppet:///modules/rtorrent/rutorrent-build.sh',
    require => User['rtorrent']
  }
  exec { 'build-rutorrent':
    command => "/home/rtorrent/rutorrent-build.sh ${rutorrent_fullwwwdir}",
    creates => $rutorrent_fullwwwdir,
    timeout => 0,
    require => [File['/home/rtorrent/rutorrent-build.sh'], Package['git']]
  }
}
