# infernal-env

A chroot+fakeroot env that may be brought up from nothing but:
- wget
- tar
- Bourne shell (sh)
- a select few POSIX utilities (`ar`, `cd`, `rm`, `mkdir` and optionally `echo`, though this list may be subject to change)

Originally intended for use with infernal-docker, albeit easily repurposeable for other tasks.

#### Please note - WIP
This is a work in progress. A lot is missing, and the few features that aren't missing are untested and prone to break things.
