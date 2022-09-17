# infernal-env

A minimal chroot+fakeroot env that may be brought up without access to a package manager, superuser privileges, common Linux utilities/packages or other utilities commonly taken for granted.

The only prerequisites are as follows:
- `wget`
- `tar`
- Bourne shell (`sh`)
- a select few POSIX utils (`ar`, `cd`, `rm`, `mkdir` and optionally `echo`, though this list may be subject to change)
- Internet connection

#### What it's for

Although initially designed for use with infernal-docker, this software may be repurposed for a myriad of other tasks. (WIP)

#### A word of warning
This is a work in progress. A lot is missing, and what isn't missing is prone to cause trouble.
