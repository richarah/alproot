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
rm -rf $BASEDIR/build/*

# See also: making wgh shell-agnostic
bash $BASEDIR/scripts/wgh.sh richarah/busybox
cd $BASEDIR/build/busybox
./build.sh && tar -xf $BASEDIR/build/busybox/stable/glibc/busybox.tar.xz -C $BASEDIR/env

# DEBUG
# rm -rf build/*
cd $BASEDIR/env
