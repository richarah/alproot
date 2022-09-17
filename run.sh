#!/bin/sh


./env/usr/bin/fakeroot-ng
chroot $PWD/env /bin/bash
