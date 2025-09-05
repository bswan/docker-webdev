#!/bin/bash

docker image rm internetrix/webdev:legacy-lap
docker build $@ -t internetrix/webdev:legacy-lap ../legacy/legacy-lap