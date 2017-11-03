#!/bin/sh

BUILD_PROFILE=$1 make clean html SPHINXOPTS="-t $1"

