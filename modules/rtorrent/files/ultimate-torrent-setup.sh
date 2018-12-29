#!/bin/bash

#Stop on first error
set -e

#Make a new libtorrent directory since we don't know the state of the old one
rm -rf /tmp/configs
cd /tmp

#Compile libtorrent
git clone https://github.com/xombiemp/ultimate-torrent-setup.git configs
mv /tmp/configs/rtorrent.rc /etc/rtorrent/
