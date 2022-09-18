FROM ubuntu:jammy

# For versions past end-of-life support
# RUN sed -i -re 's/([a-z]{2}\.)?archive.ubuntu.com|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y dist-upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \ 
    git \
    build-essential \
    automake \
    gcc-11

WORKDIR /build
RUN git clone https://github.com/richarah/fakeroot-ng

WORKDIR /build/fakeroot-ng
# Automake throws version warnings as errors - sweep these under carpet
RUN automake --add-missing; exit 0
RUN sh ./configure
RUN make
