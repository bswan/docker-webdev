#!/bin/bash

docker image rm internetrix/webdev:legacy-lap-wildcard
docker build $@ -t internetrix/webdev:legacy-lap-wildcard ../legacy/legacy-lap-wildcard