FROM ubuntu:jammy AS build

RUN alias make="make -j $(nproc)"
RUN export PATH=PATH="${PATH:+${PATH}:}~/docker"
RUN mkdir /build /docker


# Build host dependencies
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential git \
    meson bison gawk python3 python3-pip ninja-build sqlite3 libsqlite3-dev \
    libpcap-dev libcap-dev libcap-ng-dev xsltproc libpam-dev texinfo wget \
    aria2 pigz automake pkg-config libtool autoconf


# glibc
WORKDIR /build
RUN aria2c -x 16 http://ftp.gnu.org/gnu/libc/glibc-2.36.tar.gz
RUN tar -xzvf glibc-2.36.tar.gz
RUN cd glibc-2.36
WORKDIR /build/glibc-2.36/glibc-build
RUN ../configure --enable-add-ons --prefix=/docker --cache-file=.././config.cache --srcdir=.. 
RUN make
RUN make DESTDIR=/docker install
RUN rm -rf /build/*


# iputils
WORKDIR /build
RUN aria2c -x 16 https://github.com/iputils/iputils/archive/refs/tags/iputils-20211215.tar.gz
RUN tar -zxvf iputils-20211215.tar.gz
WORKDIR /build/iputils
RUN meson setup builddir && meson configure
WORKDIR /build/iputils/builddir
RUN ninja
RUN DESTDIR=/docker meson install
RUN rm -rf /build/*


# gcc
WORKDIR /build
RUN aria2c -x 16 https://ftp.gnu.org/gnu/gcc/gcc-12.2.0/gcc-12.2.0.tar.gz
RUN tar -xvzf gcc-12.2.0.tar.gz
WORKDIR /build/gcc-12.2.0
RUN ./contrib/download_prerequisites
WORKDIR /build/objdir
RUN $PWD/../gcc-12.2.0/configure --prefix=$HOME/GCC-12.2.0 --enable-languages=c,c++,fortran,go --disable-multilib
RUN make
RUN make DESTDIR=/docker install
RUN rm -rf /build/*


# util-linux
WORKDIR /build
RUN aria2c -x 16 https://github.com/util-linux/util-linux/archive/refs/tags/v2.38.1.tar.gz
RUN tar -zxvf v2.38.1.tar.gz
WORKDIR build/util-linux-2.38.1
RUN meson setup builddir && meson configure
WORKDIR /build/util-linux-2.38.1/builddir
RUN ninja
RUN DESTDIR=/docker meson install
RUN rm -rf /build/*


# talloc
WORKDIR /build
RUN aria2c -x 16 https://www.samba.org/ftp/talloc/talloc-2.3.4.tar.gz
RUN tar -zxvf talloc-2.3.4.tar.gz
WORKDIR /build/talloc-2.3.4
RUN ./configure
RUN make
RUN make DESTDIR=/docker install
RUN rm -rf /build/*


# libxcrypt
WORKDIR /build
RUN aria2c -x 16 https://github.com/besser82/libxcrypt/archive/refs/tags/v4.4.28.tar.gz
RUN tar -zxvf libxcrypt-4.4.28.tar.gz
WORKDIR /build/libxcrypt-v4.4.28
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make DESTDIR=/docker install
RUN rm -rf /build/*


# proot
WORKDIR /build
RUN aria2c -x 16 https://github.com/proot-me/proot/archive/refs/tags/v5.3.1.tar.gz
RUN tar -zxvf proot-5.3.1.tar.gz
WORKDIR /build/proot-5.3.1
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make DESTDIR=/docker install
RUN rm -rf /build/*


# busybox


# Potential libgcc: see gcc
# ../gcc-src/configure --target=$TARGET --enable-languages=c
# make all-target-libgcc
# make install-target-libgcc

 
# TODO:
# libgcc (possibly GCC)
# libstdc++ (possibly GCC)
# busybox
# Bash?

#FROM scratch AS rootfs
