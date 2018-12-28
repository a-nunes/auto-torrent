#!/bin/bash

#Stop on first error
set -e

#Allow glob to match dotfiles
shopt -s dotglob

INSTALL_FOLDER=$1

#Verify we have arguments
if [ -z ${INSTALL_FOLDER+x} ]; then
    echo 'Install folder argument missing'
    exit 1
fi

#Download rutorrent
rm -rf $INSTALL_FOLDER
mkdir $INSTALL_FOLDER
git clone https://github.com/Novik/ruTorrent.git $INSTALL_FOLDER

#Set the scgi params in rutorrent config to local socket
cd $INSTALL_FOLDER/conf
cp config.php config.php.bak
sed -i "s/^[[:space:]]*\$scgi_port \= .*/\$scgi_port \= 0;/i" config.php
sed -i "s/^[[:space:]]*\$scgi_host \= .*/\$scgi_host \= 'unix\:\/\/\/home\/rtorrent\/\.rtorrent.socket\'\;/i" config.php
