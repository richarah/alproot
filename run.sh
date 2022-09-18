#!/bin/sh
export PATH=$PATH:$PWD/env/usr/bin:$PWD/env/bin
./env/usr/bin/fakeroot-ng
chroot $PWD/env
