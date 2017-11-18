#!/bin/sh

BASEDIR=$(dirname $0)

cd "$BASEDIR"

make html SPHINXOPTS="-t boomerang"

while inotifywait -r source
do
  make html SPHINXOPTS="-t boomerang"
done
