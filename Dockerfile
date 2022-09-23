FROM ubuntu:jammy AS build-env

# Compiler flags
ARG FLAGS=" CFLAGS='-Os' CXXFLAGS='-Os' "

# Connections (aria2c)
ARG CONNS=4

RUN export PATH=PATH="${PATH:+${PATH}:}~/env"
RUN mkdir /build /env


# Dependencies for build environment
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential git \
    meson bison gawk python3 python3-pip ninja-build sqlite3 libsqlite3-dev \
    libpcap-dev libcap-dev libcap-ng-dev xsltproc libpam-dev texinfo wget \
    aria2 pigz automake pkg-config libtool autoconf iproute2 autopoint gettext \
    libncurses5-dev libncursesw5-dev uthash-dev libtalloc-dev libarchive-dev \
    libseccomp2 libseccomp-dev golang rsync 


# This could (and should) be automated, though every dependency
# has a slightly different build process...
# TODO: investigate possible solution with Portage


# glibc
# TODO: replace with musl if this proves viable, or provide option of either
WORKDIR /build
RUN aria2c -x $CONNS https://ftp.gnu.org/gnu/libc/glibc-2.36.tar.gz
RUN tar -xzvf glibc-2.36.tar.gz
RUN cd glibc-2.36
WORKDIR /build/glibc-2.36/glibc-build
RUN ../configure --enable-add-ons --prefix=/env --cache-file=.././config.cache --srcdir=.. 
RUN make -j $(nproc)
RUN make $FLAGS DESTDIR=/env install
RUN rm -rf /build/*


# util-linux
# TODO: see above note on Busybox
WORKDIR /build
RUN aria2c -x $CONNS https://github.com/util-linux/util-linux/archive/refs/tags/v2.38.1.tar.gz
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
RUN aria2c -x $CONNS https://github.com/besser82/libxcrypt/archive/refs/tags/v4.4.28.tar.gz
RUN tar -zxvf libxcrypt-4.4.28.tar.gz
WORKDIR /build/libxcrypt-4.4.28
RUN ./autogen.sh
RUN ./configure
RUN make $FLAGS -j $(nproc)
RUN make DESTDIR=/env install
RUN rm -rf /build/*


# proot
WORKDIR /build
RUN aria2c -x $CONNS https://github.com/proot-me/proot/archive/refs/tags/v5.3.1.tar.gz
RUN tar -zxvf proot-5.3.1.tar.gz
WORKDIR /build/proot-5.3.1
RUN make $FLAGS -j $(nproc) -C src loader.elf loader-m32.elf build.h
RUN make $FLAGS -j $(nproc) -C src proot care
RUN cp src/proot /usr/bin
RUN cp src/proot /env/usr/bin
RUN rm -rf /build/*


# busybox
WORKDIR /build
RUN aria2c -x $CONNS https://busybox.net/downloads/busybox-1.35.0.tar.bz2
RUN tar -xvf busybox-1.35.0.tar.bz2
WORKDIR /build/busybox-1.35.0
RUN make defconfig
RUN make $FLAGS -j $(nproc)
RUN cp busybox /env/bin
RUN rm -rf /build/*


# iputils
# TODO: switch out with Busybox' integrated iputils
WORKDIR /build
RUN aria2c -x $CONNS https://github.com/iputils/iputils/archive/refs/tags/20211215.tar.gz
RUN tar -zxvf iputils-20211215.tar.gz
WORKDIR /build/iputils-20211215
RUN meson setup builddir && meson configure
WORKDIR /build/iputils-20211215/builddir
RUN ninja
RUN DESTDIR=/env meson install
RUN rm -rf /build/*

# bash
WORKDIR /build
RUN aria2c -x $CONNS https://ftp.gnu.org/gnu/bash/bash-1.14.7.tar.gz
RUN tar -xzvf bash-1.14.7.tar.gz
WORKDIR build/bash-1.14.7
RUN ./configure
RUN make $FLAGS -j $(nproc)
RUN cp bash /env/bin
RUN rm -rf /build/*


# Hack to fix path glitch (do this properly someday) prior to Busybox install
RUN rsync -a /env/env /tmp/env
RUN rm -rf /env/env
RUN rsync -a /tmp/env/env/* /env/
RUN rm -rf /tmp/env
RUN rm -rf /build


# Temporary solution. Also gives us Bash and FHS standard dirtree
# TODO: rewrite
FROM scratch AS busybox-installer
COPY --from=build-env /env /
WORKDIR /bin
RUN exec /bin/busybox --install -s /bin

# Internet
WORKDIR /etc
RUN touch resolv.conf && echo "nameserver 8.8.8.8" >> resolv.conf

# Users
RUN echo "root:x:0:0:root:/root:/bin/sh" >> /etc/passwd
RUN echo "mirage:x:1000:1000:Mirage,,,:/home/mirage:/bin/sh" >> /etc/passwd

FROM scratch AS rootfs
COPY --from=busybox-installer / /
WORKDIR /
CMD ./bin/busybox
