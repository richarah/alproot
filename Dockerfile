FROM ubuntu:jammy AS mirage-ubuntu-build

RUN export PATH=PATH="${PATH:+${PATH}:}~/docker"
RUN mkdir /build /docker


# Build host dependencies
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential git \
    meson bison gawk python3 python3-pip ninja-build sqlite3 libsqlite3-dev \
    libpcap-dev libcap-dev libcap-ng-dev xsltproc libpam-dev texinfo wget \
    aria2 pigz automake pkg-config libtool autoconf iproute2


FROM mirage-ubuntu-build as mirage-glibc-build

# glibc
WORKDIR /build
RUN aria2c -x 16 https://ftp.gnu.org/gnu/libc/glibc-2.36.tar.gz
RUN tar -xzvf glibc-2.36.tar.gz
RUN cd glibc-2.36
WORKDIR /build/glibc-2.36/glibc-build
RUN ../configure --enable-add-ons --prefix=/docker --cache-file=.././config.cache --srcdir=.. 
RUN make -j $(nproc)
RUN make DESTDIR=/docker install
RUN rm -rf /build/*


FROM mirage-glibc-build as mirage-gcc-build

# gcc
WORKDIR /build
RUN aria2c -x 16 https://ftp.gnu.org/gnu/gcc/gcc-12.2.0/gcc-12.2.0.tar.gz
RUN tar -xvzf gcc-12.2.0.tar.gz
WORKDIR /build/gcc-12.2.0
RUN ./contrib/download_prerequisites
WORKDIR /build/objdir
RUN $PWD/../gcc-12.2.0/configure --prefix=$HOME/GCC-12.2.0 --enable-languages=c,c++,fortran,go --disable-multilib
RUN make -j $(nproc)
RUN make DESTDIR=/docker install
RUN rm -rf /build/*


FROM mirage-gcc-build AS mirage-iputils-build

# iputils
WORKDIR /build
RUN aria2c -x 16 https://github.com/iputils/iputils/archive/refs/tags/20211215.tar.gz
RUN tar -zxvf iputils-20211215.tar.gz
WORKDIR /build/iputils-20211215
RUN meson setup builddir && meson configure
WORKDIR /build/iputils-20211215/builddir
RUN ninja
RUN DESTDIR=/docker meson install
RUN rm -rf /build/*


FROM mirage-iputils-build AS mirage-util-linux-build

# TEMP
RUN apt-get install -y autopoint gettext libncurses5-dev libncursesw5-dev


# util-linux
WORKDIR /build
RUN aria2c -x 16 https://github.com/util-linux/util-linux/archive/refs/tags/v2.38.1.tar.gz
RUN tar -zxvf util-linux-2.38.1.tar.gz
WORKDIR /build/util-linux-2.38.1
RUN ./autogen.sh
RUN meson setup builddir && meson configure
WORKDIR /build/util-linux-2.38.1/builddir
RUN ninja
RUN DESTDIR=/docker meson install
RUN rm -rf /build/*


FROM mirage-util-linux-build AS mirage-talloc-build

# talloc
WORKDIR /build
RUN aria2c -x 16 https://www.samba.org/ftp/talloc/talloc-2.3.4.tar.gz
RUN tar -zxvf talloc-2.3.4.tar.gz
WORKDIR /build/talloc-2.3.4
RUN ./configure
RUN make -j $(nproc)
RUN make DESTDIR=/docker install
RUN rm -rf /build/*


FROM mirage-talloc-build AS mirage-libxcrypt-build

# libxcrypt
WORKDIR /build
RUN aria2c -x 16 https://github.com/besser82/libxcrypt/archive/refs/tags/v4.4.28.tar.gz
RUN tar -zxvf libxcrypt-4.4.28.tar.gz
WORKDIR /build/libxcrypt-v4.4.28
RUN ./autogen.sh
RUN ./configure
RUN make -j $(nproc)
RUN make DESTDIR=/docker install
RUN rm -rf /build/*


FROM mirage-libxcrypt-build AS mirage-proot-build

# proot
WORKDIR /build
RUN aria2c -x 16 https://github.com/proot-me/proot/archive/refs/tags/v5.3.1.tar.gz
RUN tar -zxvf proot-5.3.1.tar.gz
WORKDIR /build/proot-5.3.1
RUN ./autogen.sh
RUN ./configure
RUN make -j $(nproc)
RUN make DESTDIR=/docker install
RUN rm -rf /build/*


FROM mirage-proot-build AS mirage-busybox-build

# busybox
WORKDIR /build
RUN aria2c -x 16 https://busybox.net/downloads/busybox-1.35.0.tar.bz2
RUN tar -xvf busybox-1.35.0.tar.gz
WORKDIR /build/busybox-1.35.0
RUN make defconfig
RUN make -j $(nproc)
RUN make DESTDIR=/docker install
RUN rm -rf /build/*


FROM mirage-busybox-build AS mirage-bash-build

# bash
WORKDIR /build
RUN aria2c -x 16 https://ftpmirror.gnu.org/gnu/bash/bash-5.2-rc4.tar.gz
RUN tar -xzvf bash-5.2-rc4.tar.gz
WORKDIR /build/bash-5.2-rc4.tar.gz
RUN ./configure
RUN make -j $(nproc)
RUN make DESTDIR=/docker install
RUN rm -rf /build/*

# Potential libgcc: see gcc
# ../gcc-src/configure --target=$TARGET --enable-languages=c
# make all-target-libgcc
# make install-target-libgcc

 
# TODO:
# libgcc (possibly GCC)
# libstdc++ (possibly GCC)

#FROM scratch AS rootfs
