#!/bin/bash

./update_lap.sh $@
./update_lap-wildcard.sh $@
./build_legacy-lap.sh
./build_legacy-lap-wildcard.sh