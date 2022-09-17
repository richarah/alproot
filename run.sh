#!/bin/sh
cd env
export fakechroot="./usr/bin/fakechroot --use-system-libs"
fakechroot fakeroot chroot $(dirname "$0")/env /bin/sh
