#!/bin/sh
docker build . -t alproot-env && docker export $(docker create alproot-env) -o alproot-env.tar && pv alproot-env.tar | pigz -11 > img/alproot-env.tar.gz && rm -rf alproot-env.tar
