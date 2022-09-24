#!/bin/sh
rm -rf env && mkdir env && \
wget https://github.com/richarah/alproot/releases/download/stable/alproot-env.tar.gz && \
tar -xzvf alproot-env.tar.gz -C env && \
echo "Setup complete.\nRun ./alproot.sh to enter the Alproot environment."
