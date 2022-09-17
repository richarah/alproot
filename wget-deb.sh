#!/bin/sh

BASEDIR=$PWD

URL=$1
ARCHIVE=$( echo ${URL##*/} )

wget $URL -P build
ar vx $BASEDIR/build/$ARCHIVE --output build
tar -xvf $BASEDIR/build/data.tar.xz -C $BASEDIR/env
rm -rfv $BASEDIR/build/data.tar.xz
