#!/bin/sh

BASEDIR=$PWD

mkdir build
mkdir env
rm -rfv ./build/*
rm -rfv ./env/*

# TODO: procedural programming and building from source
cd $BASEDIR/build

wget http://ftp.debian.org/debian/pool/main/b/bash/bash_5.1-2+deb11u1_amd64.deb
ar vx $BASEDIR/build/bash_5.1-2+deb11u1_amd64.deb
tar -xvf $BASEDIR/build/data.tar.xz -C ../env
rm -rfv $BASEDIR/build/data.tar.xz

wget http://ftp.debian.org/debian/pool/main/f/fakechroot/fakechroot_2.19-3.3_all.deb
ar vx $BASEDIR/build/fakechroot_2.19-3.3_all.deb
tar -xvf $BASEDIR/build/data.tar.xz -C ../env
rm -rfv $BASEDIR/build/data.tar.xz

wget http://ftp.debian.org/debian/pool/main/f/fakeroot/libfakeroot_1.25.3-1.1_amd64.deb
ar vx $BASEDIR/build/libfakeroot_1.25.3-1.1_amd64.deb
tar -xvf $BASEDIR/build/data.tar.xz -C ../env
rm -rfv $BASEDIR/build/data.tar.xz

rm -rfv build/*
echo "Ready."
