#!/bin/sh
cd env

DEFAULTARGS="busybox sh"
ARGS="${@:-$DEFAULTARGS}"

# Fixes for PATH not updating correctly in docker
PATH=$PATH:./bin:./usr/bin
proot -r . -0 -w / -b /dev -b /proc -b /sys -b /boot -b /etc/resolv.conf $ARGS
