#### A word of warning

This is a work in progress. A lot of functionality is missing, prone to bizarre behaviour and/or a security incident waiting to happen.

Also note that proot's root UID spoofing does not provide any true privilege escalation, meaning programs requiring true root privileges outside the sandbox (e.g. to modify the kernel or interface with hardware) will not work.

# Alproot

## What is this?

Alproot is a lightweight, truly rootless, Alpine-based sandbox environment running in `proot` instead of a traditional `fakeroot`/`chroot` sandbox.

May be brought up without access to a package manager, superuser privileges, `LD_PRELOAD` tricks, preinstalled `fakeroot` or other luxuries commonly taken for granted when setting up such environments.

## Motivation

The project aims to provide a truly rootless (i.e. rootless to set up and configure, not only to run) alternative to established out-of-the-box `chroot` environments such as `debootstrap` and `alpine-chroot`, while also maintaining a significantly smaller footprint than extant alternatives (~10MB)

#### Truly rootless?

While a wide range of supposedly rootless sandboxes are available, most of these require superuser privileges to actually *set up*, pull in a variety of dependencies which require access to system-wide resources. In other words, these may not be rootless in practice if the host does not already have these dependencies installed.

## Setup and run

```
# Fetch and extract root file system
wget https://github.com/richarah/alproot/releases/download/stable/alproot-env.tar.gz
tar -xzvf alproot-env.tar.gz -C env
# Initialise & enter proot environment
./alproot.sh
```

## Build Alproot rootfs
Ensure that your machine has Git and Docker installed, then clone the repository and build the root file system and alproot dependencies as follows:
```
git clone https://github.com/richarah/alproot
cd alproot
./alproot-build.sh
```
