#!/bin/sh

BASEDIR=$PWD

# DEBUG
# rm -rfv ./build/*
rm -rfv ./env/*

# TODO: procedural programming and building from source
cd $BASEDIR/build

wget http://ftp.debian.org/debian/pool/main/b/bash/bash_5.1-2+deb11u1_amd64.deb
ar vx $BASEDIR/build/bash_5.1-2+deb11u1_amd64.deb
tar -xf $BASEDIR/build/data.tar.xz -C ../env
rm -rf $BASEDIR/build/data.tar.xz

wget http://ftp.debian.org/debian/pool/main/f/fakechroot/fakechroot_2.19-3.3_all.deb
ar vx $BASEDIR/build/fakechroot_2.19-3.3_all.deb
tar -xf $BASEDIR/build/data.tar.xz -C ../env
rm -rf $BASEDIR/build/data.tar.xz

# See also: making wgh shell-agnostic
# bash $BASEDIR/scripts/wgh.sh richarah/busybox
# cd $BASEDIR/build/busybox
# ./build.sh
# tar -xf $BASEDIR/build/busybox/stable/glibc/busybox.tar.xz -C $BASEDIR/env

# DEBUG
# rm -rf build/*
