#!/bin/bash

#Stop on first error
set -e

chown -R rtorrent:media /var/lib/rtorrent/*
mv ~/configs/rtorrent.service /etc/systemd/system/

# sudo systemctl enable rtorrent.service