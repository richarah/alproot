#!/bin/sh
docker build . -t alproot-env && docker export $(docker create alproot-env) -o alproot-env.tar && tar -zxvf -11 alproot-env.tar
