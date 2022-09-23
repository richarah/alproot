#!/bin/sh
docker build . -t alproot-env && docker export $(docker create alproot-env) -o alproot-env.tar && pigz -11 alproot-env.tar
