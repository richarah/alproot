FROM ubuntu:jammy AS build-env

RUN mkdir /build /docker

WORKDIR /build

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential git meson bison gawk python3 python3-pip ninja-build sqlite3 libsqlite3-dev libpcap-dev libcap-dev xsltproc

RUN git clone https://sourceware.org/git/glibc.git
RUN cd glibc && git checkout release/2.36/master
WORKDIR /build/glibc/glibc-build
RUN ../configure --enable-add-ons --prefix=/docker --cache-file=.././config.cache --srcdir=. 
RUN make



WORKDIR /build

RUN git clone https://github.com/iputils/iputils.git
RUN ./configure && make && make DESTDIR=/docker install

# RUN cd builddir && meson install

#FROM scratch AS rootfs
