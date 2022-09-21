FROM ubuntu:jammy AS build

RUN mkdir /build /docker


# Build host dependencies
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential git \
    meson bison gawk python3 python3-pip ninja-build sqlite3 libsqlite3-dev \
    libpcap-dev libcap-dev libcap-ng-dev xsltproc libpam-dev texinfo wget


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
# NOTE: Meson build as described in docs did not work, ergo using ninja
WORKDIR /build
RUN git clone https://github.com/iputils/iputils.git
WORKDIR /build/iputils
RUN meson setup builddir && meson configure
WORKDIR /build/iputils/builddir
RUN ninja
RUN DESTDIR=/docker meson install
RUN rm -rf /build/*


# GCC
WORKDIR /build
RUN tar -xvzf gcc-4.6.2.tar.gz
WORKDIR /build/gcc-4.6.2
RUN ./contrib/download_prerequisites
WORKDIR /build/objdir
#RUN $PWD/../gcc-4.6.2/configure --prefix=$HOME/GCC-4.6.2 --enable-languages=c,c++,fortran,go
RUN $PWD/../gcc-4.6.2/configure --prefix=$HOME/GCC-4.6.2 --enable-languages=c,c++,fortran
RUN make all
RUN make install
RUN rm -rf /build/*


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
RUN https://www.samba.org/ftp/talloc/talloc-2.3.4.tar.gz
RUN tar -zxvf talloc-2.3.4.tar.gz
WORKDIR /build/talloc-2.3.4
RUN ./configure
RUN make
RUN make DESTDIR=/docker install
RUN rm -rf /build/*


#FROM scratch AS rootfs
