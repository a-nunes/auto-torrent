puppet-rtorrent-nginx
=====================

A puppet module to install libtorrent and rtorrent from source, with the xmlrpc-c extension, as well as the rutorrent frontend, all on nginx.

The module has been divided into 4 independant stages that by default are all executed. Tested on Ubuntu 14.04 and 14.10

You can run this build with the command puppet apply --modulepath=./modules manifests/rtorrent.pp

## Stage 1: Build rtorrent

1. Installs required build dependencies, see [the build manifest for packages that are installed](manifests/rtorrent_build.pp)
2. [Builds libtorrent and rtorrent](files/rtorrent-build.sh). Roughly does
 * Clones libtorrent from official github repo
 * ./configure --with-posix-fallocate
 * make and make install
 * ldconfig
 * Clones rtorrent from official github repo
 * ./configure --with-xmlrpc-c=/usr/bin/xmlrpc-c-config
 * make and make install

## Stage 2: Configure rtorrent

1. Creates dedicated rtorrent user
2. Creates /var/run/rtorrent for temp work
3. Creates a default .rtorrent.rc.puppet . Due to the complexity of configuring this file you can symlink to the puppet provided one or create your own
4. Creates a service in /etc/init.d to start rtorrent

## Stage 3: Build and configure rutorrent

1. Clones rutorrent from official github repo
2. Configures to use rtorrent scgi socket file

## (OPTIONAL) Stage 4: Setup nginx

If you do not have an existing nginx or apache server setup you can use rtorrent::nginx_php which will setup a nginx webserver with php5.

This is not enabled by default
