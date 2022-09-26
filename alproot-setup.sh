#!/bin/sh
rm -rf env img && \
mkdir env img && \
wget -O img/alproot-env.tar.gz https://github.com/richarah/alproot/releases/download/stable/alproot-env.tar.gz && \
tar -xzvf img/alproot-env.tar.gz -C env && \
echo "Setup complete.\nRun ./alproot.sh to enter the Alproot environment."
