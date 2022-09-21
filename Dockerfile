FROM ubuntu:jammy AS build

RUN alias make="make -j $(nproc)"

# TODO: split into layers and replace wget with aria2
# e.g. aria2c -x 16 [url]
# Concurrency

RUN mkdir /build /docker

# Build host dependencies
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential git \
    meson bison gawk python3 python3-pip ninja-build sqlite3 libsqlite3-dev \
    libpcap-dev libcap-dev libcap-ng-dev xsltproc libpam-dev texinfo wget aria2


# glibc
WORKDIR /build
RUN wget http://ftp.gnu.org/gnu/libc/glibc-2.36.tar.gz
RUN tar -xzvf glibc-2.36.tar.gz
RUN cd glibc-2.36
WORKDIR /build/glibc-2.36/glibc-build
RUN ../configure --enable-add-ons --prefix=/docker --cache-file=.././config.cache --srcdir=.. 
RUN make
RUN make DESTDIR=/docker install
RUN rm -rf /build/*


# iputils
WORKDIR /build
RUN https://github.com/iputils/iputils/archive/refs/tags/20211215.tar.gz
RUN tar -zxvf 20211215.tar.gz
WORKDIR /build/iputils
RUN meson setup builddir && meson configure
WORKDIR /build/iputils/builddir
RUN ninja
RUN DESTDIR=/docker meson install
RUN rm -rf /build/*


# gcc
WORKDIR /build
RUN wget https://ftp.gnu.org/gnu/gcc/gcc-12.2.0/gcc-12.2.0.tar.gz
RUN tar -xvzf gcc-12.2.0.tar.gz
WORKDIR /build/gcc-12.2.0
RUN ./contrib/download_prerequisites
WORKDIR /build/objdir
RUN $PWD/../gcc-12.2.0/configure --prefix=$HOME/GCC-12.2.0 --enable-languages=c,c++,fortran,go --disable-multilib
RUN make
RUN make install
RUN rm -rf /build/*


# libgcc



# util-linux
WORKDIR /build
RUN wget https://github.com/util-linux/util-linux/archive/refs/tags/v2.38.1.tar.gz
RUN tar -zxvf v2.38.1.tar.gz
WORKDIR build/util-linux-2.38.1
RUN meson setup builddir && meson configure
WORKDIR /build/util-linux-2.38.1/builddir
RUN ninja
RUN DESTDIR=/docker meson install
RUN rm -rf /build/*


# talloc
RUN wget https://www.samba.org/ftp/talloc/talloc-2.3.4.tar.gz
RUN tar -zxvf talloc-2.3.4.tar.gz
WORKDIR /build/talloc-2.3.4
RUN ./configure
RUN make
RUN make DESTDIR=/docker install
RUN rm -rf /build/*


# TODO:
# libgcc
# glibc
# libstdc++
# libxcrypt/libcrypt1.4.4.18-4
# proot
# busybox
# Bash?

#FROM scratch AS rootfs
