#!/bin/sh

BASEDIR=$PWD

rm -rfv ./build/* ./env/*

mkdir build
mkdir env

# TODO: build from source
cd $BASEDIR/build
wget http://ftp.debian.org/debian/pool/main/f/fakechroot/fakechroot_2.19-3.3_all.deb
ar vx *.deb
tar -xf data.tar.xz -C ../env

# See also: making wgh sh-compatible
bash $BASEDIR/wgh.sh richarah/busybox

# DEBUG
# rm -rf build
cd $BASEDIR/env
