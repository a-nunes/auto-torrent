#!/bin/bash

#Stop on first error
set -e

BUILD_FOLDER="/usr/local/src"

#Make a new libtorrent directory since we don't know the state of the old one
rm -rf $BUILD_FOLDER/libtorrent
cd $BUILD_FOLDER

#Compile libtorrent
git clone https://github.com/rakshasa/libtorrent.git
cd libtorrent
./autogen.sh
./configure
make
make install
