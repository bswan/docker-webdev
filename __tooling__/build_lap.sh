#!/bin/bash

docker image rm internetrix/webdev:lap
docker build $@ -t internetrix/webdev:lap ../lap