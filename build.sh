#!/bin/bash -e
cd $(dirname $0)
mkdir -p build
cd build
docker build -t build-opencv-static -f ../Dockerfile .
# extract the static built opencv
docker run -v $(pwd):/mnt --rm build-opencv-static bash -c 'cp -R -v /target/* /mnt/'

