#!/bin/sh
docker build . -t alproot-env && docker export $(docker create alproot-env) -o alproot-env.tar && tar cvf alproot-env.tar.xz --use-compress-program='xz -9eT'$(nproc) alproot-env.tar && rm -rf alproot-env.tar
