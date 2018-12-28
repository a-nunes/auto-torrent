#!/bin/bash

#Stop on first error
set -e

BUILD_FOLDER="/usr/local/src"

#Make a new xmlrpc directory since we don't know the state of the old one
rm -rf $BUILD_FOLDER/xmlrpc-c
cd $BUILD_FOLDER

#Compile xmlrpc
svn checkout https://svn.code.sf.net/p/xmlrpc-c/code/stable xmlrpc-c
cd xmlrpc-c
./configure
make
make install
