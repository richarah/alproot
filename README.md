#### A word of warning

This is a work in progress. A lot of functionality is missing, prone to bizarre behaviour and/or a security incident waiting to happen.

Also note that proot's root UID spoofing does not provide any true privilege escalation, meaning programs requiring true root privileges outside the sandbox (e.g. to modify the kernel or interface with hardware) will not work.

# Alproot

## What is this?

Alproot is a lightweight (<10MB), truly rootless, Alpine-based sandbox environment running in `proot` instead of a traditional `fakeroot`/`chroot` sandbox.

May be brought up without access to a package manager, superuser privileges, `LD_PRELOAD` tricks, preinstalled `fakeroot` or other luxuries commonly taken for granted when setting up such environments.

## Setup and run

```
# Extract rootfs
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
