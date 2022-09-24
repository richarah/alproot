#!/bin/sh
cd env

DEFAULTARGS="busybox sh"
ARGS="${@:-$DEFAULTARGS}"

# Fixes for PATH and /etc/resolv.conf not updating correctly in docker
PATH=$PATH:./bin:./usr/bin
echo "nameserver 8.8.8.8" >> etc/resolv.conf

proot -r . -0 -w / -b /dev -b /proc -b /sys $ARGS
