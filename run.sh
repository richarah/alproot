#!/bin/sh
cd env
PATH=$PATH:./bin:./usr/bin
proot -r . -0 -w / -b /dev -b /proc -b /sys -b /etc busybox sh
