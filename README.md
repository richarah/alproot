#### A word of warning

This is a work in progress. A lot of functionality is missing, prone to bizarre behaviour and/or a security incident waiting to happen.

Also note that proot's root UID spoofing does not provide any true privilege escalation, meaning programs requiring true root privileges outside the sandbox (e.g. to modify the kernel or interface with hardware) will not work.

# Alproot

#### What is this?

Alproot (`alpine`+`proot`) is a lightweight, Alpine Linux-based sandbox environment running in `proot` instead of a traditional `fakeroot`+`chroot` env.

May be brought up without access to a package manager, superuser privileges, `LD_PRELOAD`, preinstalled `fakeroot` or other luxuries commonly taken for granted when setting up such environments.

## Setup and run

Clone the repository, run the one-time `alproot-setup.sh` script and use `alproot.sh` to bring up the BusyBox environment:
```
git clone https://github.com/richarah/alproot.git
cd alproot
# Setup env (should take ~10 seconds)
./alproot-setup.sh
# Enter proot env
./alproot.sh
```
