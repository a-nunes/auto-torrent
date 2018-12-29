#
# ==== Class: rtorrent::rtorrent_config
#
# Configures rtorrent enviornment. Creates a dedicated rtorrent user (password rtorrent),
# rtorrent init.d service, run directory, .rtorrent.rc config, and starts the rtorrent service
#
# ==== Parameters:
#
# TODO
#
class rtorrent::rtorrent_config(
  $rtorrent_command
) {
  file {
    '/home/rtorrent/.rtorrent.rc.puppet':
      ensure  => present,
      owner   => 'rtorrent',
      group   => 'rtorrent',
      mode    => '0440',
      content => template('rtorrent/rtorrent.rc.erb'),
      require => [ User['rtorrent'], File['/var/run/rtorrent'] ],
      notify  => Service['rtorrent'];
    # Configure and start rtorrent service
    '/etc/init.d/rtorrent':
      ensure  => present,
      owner   => 'rtorrent',
      group   => 'rtorrent',
      mode    => '0555',
      content => template('rtorrent/rtorrent.erb'),
      require => User['rtorrent'];
  }

  service { 'rtorrent':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
    require    => Class['rtorrent::rtorrent_build'];
  }
}
