#!/bin/bash
VIDEO=$1

docker run --rm -ti -v $(pwd):/opt -w /opt jrottenberg/ffmpeg:4.4-ubuntu -i "$VIDEO" 2>&1 | grep Stream | grep Audio | perl -pe 's/.*/true/'
