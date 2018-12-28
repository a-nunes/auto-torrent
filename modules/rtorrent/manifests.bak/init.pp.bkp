# == Class: rtorrent
#
class rtorrent(
  $vhost,
  $rtorrent_download_rate = 1500,
  $rtorrent_upload_rate = 20,
  $rtorrent_max_uploads = 8,
  $rtorrent_session = '/quackdrive/torrents/rtsession',
  $rtorrent_directory = '/quackdrive/torrents',
  $www_dir = '/var/www',
  $rutorrent_wwwdir = 'rutorrent',
  $rtorrent_command = '/usr/local/bin/rtorrent -D'
) {
  class { 'rtorrent::rtorrent_build': }
  class { 'rtorrent::rtorrent_config':
    rtorrent_command => $rtorrent_command;
  }
  class { 'rtorrent::rutorrent':
    rutorrent_fullwwwdir => "${www_dir}/${rutorrent_wwwdir}";
  }
}
