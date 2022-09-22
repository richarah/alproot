FROM ubuntu:jammy AS mirage-build

RUN export PATH=PATH="${PATH:+${PATH}:}~/env"
RUN mkdir /build /env


# Build host dependencies
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential git \
    meson bison gawk python3 python3-pip ninja-build sqlite3 libsqlite3-dev \
    libpcap-dev libcap-dev libcap-ng-dev xsltproc libpam-dev texinfo wget \
    aria2 pigz automake pkg-config libtool autoconf iproute2 autopoint gettext \
    libncurses5-dev libncursesw5-dev uthash-dev libtalloc-dev libarchive-dev \
    libseccomp2 libseccomp-dev golang


# This could be scripted, but every dependency has a slightly different build process...

# glibc
# TODO: replace with musl if this proves viable, or provide option of either
WORKDIR /build
RUN aria2c -x 16 https://ftp.gnu.org/gnu/libc/glibc-2.36.tar.gz
RUN tar -xzvf glibc-2.36.tar.gz
RUN cd glibc-2.36
WORKDIR /build/glibc-2.36/glibc-build
RUN ../configure --enable-add-ons --prefix=/env --cache-file=.././config.cache --srcdir=.. 
RUN make -j $(nproc)
RUN make DESTDIR=/env install
RUN rm -rf /build/*


# iputils
# TODO: switch out with Busybox' integrated iputils
WORKDIR /build
RUN aria2c -x 16 https://github.com/iputils/iputils/archive/refs/tags/20211215.tar.gz
RUN tar -zxvf iputils-20211215.tar.gz
WORKDIR /build/iputils-20211215
RUN meson setup builddir && meson configure
WORKDIR /build/iputils-20211215/builddir
RUN ninja
RUN DESTDIR=/env meson install
RUN rm -rf /build/*


# util-linux
# TODO: see above note on Busybox
WORKDIR /build
RUN aria2c -x 16 https://github.com/util-linux/util-linux/archive/refs/tags/v2.38.1.tar.gz
RUN tar -zxvf util-linux-2.38.1.tar.gz
WORKDIR /build/util-linux-2.38.1
RUN ./autogen.sh
RUN meson setup builddir && meson configure
WORKDIR /build/util-linux-2.38.1/builddir
RUN ninja
RUN DESTDIR=/env meson install
RUN rm -rf /build/*


# libxcrypt
WORKDIR /build
RUN aria2c -x 16 https://github.com/besser82/libxcrypt/archive/refs/tags/v4.4.28.tar.gz
RUN tar -zxvf libxcrypt-4.4.28.tar.gz
WORKDIR /build/libxcrypt-4.4.28
RUN ./autogen.sh
RUN ./configure
RUN make -j $(nproc)
RUN make DESTDIR=/env install
RUN rm -rf /build/*


# proot
WORKDIR /build
RUN aria2c -x 16 https://github.com/proot-me/proot/archive/refs/tags/v5.3.1.tar.gz
RUN tar -zxvf proot-5.3.1.tar.gz
WORKDIR /build/proot-5.3.1
RUN make -j $(nproc) -C src loader.elf loader-m32.elf build.h
RUN make -j $(nproc) -C src proot care
RUN cp src/proot /usr/bin
RUN cp src/proot /env/usr/bin
RUN rm -rf /build/*


# busybox
WORKDIR /build
RUN aria2c -x 16 https://busybox.net/downloads/busybox-1.35.0.tar.bz2
RUN tar -xvf busybox-1.35.0.tar.bz2
WORKDIR /build/busybox-1.35.0
RUN make defconfig
RUN make -j $(nproc)
RUN make DESTDIR=/env install
RUN rm -rf /build/*


# bash (keymap currently broken, but some programs demand bash)
WORKDIR /build
RUN aria2c -x 16 https://ftp.gnu.org/gnu/bash/bash-5.2-rc4.tar.gz
RUN tar -xzvf bash-5.2-rc4.tar.gz
WORKDIR /build/bash-5.2-rc4
RUN ./configure
RUN make -j $(nproc)
RUN make DESTDIR=/env install
RUN rm -rf /build/*


# Hack to fix path glitch (do this properly someday)
RUN mv -vf /env/env/* /env/ && rm -rvf /env/env


# TODO
#FROM scratch AS rootfs


