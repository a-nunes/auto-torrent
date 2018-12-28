#!/bin/bash

#Stop on first error
set -e

BUILD_FOLDER="/usr/local/src"

#Make a new libtorrent directory since we don't know the state of the old one
rm -rf $BUILD_FOLDER/rtorrent
cd $BUILD_FOLDER

#Compile libtorrent
git clone https://github.com/rakshasa/rtorrent.git
cd rtorrent
./autogen.sh
./configure --with-xmlrpc-c
make
make install
ln -s /usr/local/bin/rtorrent /usr/bin/
