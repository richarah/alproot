FROM ubuntu:jammy AS build

RUN mkdir /build /docker


# Build host dependencies
WORKDIR /build
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential git \
    meson bison gawk python3 python3-pip ninja-build sqlite3 libsqlite3-dev \
    libpcap-dev libcap-dev xsltproc


# glibc
RUN git clone https://sourceware.org/git/glibc.git
RUN cd glibc && git checkout release/2.36/master
WORKDIR /build/glibc/glibc-build
RUN ../configure --enable-add-ons --prefix=/docker --cache-file=.././config.cache --srcdir=.. 
RUN make DESTDIR=/docker install


# iputils
# NOTE: Meson build as described in docs did not work, ergo using ninja
WORKDIR /build
RUN git clone https://github.com/iputils/iputils.git
WORKDIR /build/iputils
RUN meson setup builddir && meson configure
WORKDIR /build/iputils/builddir
RUN ninja
RUN DESTDIR=/docker meson install


# GCC
WORKDIR /build
RUN tar xzf gcc-4.6.2.tar.gz
WORKDIR /build/gcc-4.6.2
RUN ./contrib/download_prerequisites
WORKDIR /build/objdir
RUN $PWD/../gcc-4.6.2/configure --prefix=$HOME/GCC-4.6.2 --enable-languages=c,c++,fortran,go
RUN make
RUN make install


#FROM scratch AS rootfs
