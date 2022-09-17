#!/bin/sh

BASEDIR=$PWD

rm -rf build
rm -rf env

mkdir build
mkdir env

alias wgd="sh $BASEDIR/wget-deb.sh"

# C/C++
wgd http://ftp.debian.org/debian/pool/main/g/gcc-10/gcc-10-base_10.2.1-6_amd64.deb
wgd http://ftp.debian.org/debian/pool/main/g/glibc/libc6_2.31-13+deb11u4_amd64.deb
wgd http://ftp.debian.org/debian/pool/main/libx/libxcrypt/libcrypt1_4.4.18-4_amd64.deb
wgd http://ftp.debian.org/debian/pool/main/n/ncurses/libtinfo6_6.2+20201114-2_amd64.deb
wgd http://ftp.debian.org/debian/pool/main/g/gcc-10/libgcc-s1_10.2.1-6_amd64.deb
wgd http://ftp.debian.org/debian/pool/main/g/gcc-10/libstdc++6_10.2.1-6_amd64.deb

# Shell & utils
wgd http://ftp.debian.org/debian/pool/main/b/bash/bash_5.1-2+deb11u1_amd64.deb
wgd http://ftp.debian.org/debian/pool/main/f/fakeroot-ng/fakeroot-ng_0.18-4.1_amd64.deb

rm -rf debian-binary
rm -rf build
