#!/bin/bash

#Stop on first error
set -e

#Make a new libtorrent directory since we don't know the state of the old one
rm -rf ~/configs
cd ~

#Compile libtorrent
git clone https://github.com/xombiemp/ultimate-torrent-setup.git configs
mv ~/configs/rtorrent.rc /etc/rtorrent/
