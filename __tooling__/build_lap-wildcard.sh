#!/bin/bash

docker image rm internetrix/webdev:lap-wildcard
docker image rm internetrix/webdev:latest
docker build $@ -t internetrix/webdev:lap-wildcard ../lap-wildcard
docker image tag internetrix/webdev:lap-wildcard internetrix/webdev:latest