#!/bin/sh
export fakechroot="./env/usr/bin/fakechroot"
fakechroot fakeroot chroot env /bin/bash
