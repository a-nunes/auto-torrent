#!/bin/bash

#Stop on first error
set -e

apt-get update
apt-get full-upgrade -y
