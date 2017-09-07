#!/bin/bash
# Setup a user-defined bridge network, so that the embedded DNS server can resovle container name to internal IP.
# 
# Please add webdev related containers into 'isolated_nw_webdev' network.
#
# Ref
#	- https://docs.docker.com/engine/userguide/networking/configure-dns/
#	- https://docs.docker.com/engine/userguide/networking/work-with-networks/#basic-container-networking-example

docker network create -d bridge --subnet 172.30.0.0/16 isolated_nw_webdev