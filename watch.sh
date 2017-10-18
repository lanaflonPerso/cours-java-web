#!/bin/sh

BASEDIR=$(dirname $0)

cd "$BASEDIR"

make html

while inotifywait -r source
do
  make html
done
