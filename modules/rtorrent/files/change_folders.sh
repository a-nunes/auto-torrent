#!/bin/bash

#Stop on first error
set -e

chown -R rtorrent:media /var/lib/rtorrent/*
mv /tmp/configs/rtorrent.service /etc/systemd/system/
mv /tmp/configs/update-rutorrent /usr/local/bin/

# sudo systemctl enable rtorrent.service
