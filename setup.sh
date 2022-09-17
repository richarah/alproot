#!/bin/sh

BASEDIR=$PWD

# DEBUG
# rm -rfv ./build/*
rm -rfv ./env/*

# TODO: build from source
cd $BASEDIR/build
wget http://ftp.debian.org/debian/pool/main/f/fakechroot/fakechroot_2.19-3.3_all.deb
ar vx *.deb
tar -xf $BASEDIR/build/data.tar.xz -C ../env
rm -rf $BASEDIR/build/data.tar.xz

# See also: making wgh shell-agnostic
# bash $BASEDIR/scripts/wgh.sh richarah/busybox
# cd $BASEDIR/build/busybox
# ./build.sh
tar -xf $BASEDIR/build/busybox/stable/glibc/busybox.tar.xz -C $BASEDIR/env

# DEBUG
# rm -rf build/*
