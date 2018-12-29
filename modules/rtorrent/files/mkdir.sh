#!/bin/bash

#Stop on first error
set -e

# creates all folders to install the softwares
mkdir /data
cd /data
mkdir -p torrent/{complete/{movie/radarr,music,tv/sonarr,game,book,software,other},download/{movie/radarr,music,tv/sonarr,game,book,software,other},watch/{movie/radarr,music,tv/sonarr,game,book,software,other}} Media/{Movies,'TV Shows'}
chown -R $USER:media /data/*
chmod -R 775 /data/*
find /data/* -type d -exec chmod g+s {} +
find /data/* -type d -exec setfacl -m default:group::rwX {} +
