#!/bin/bash
VIDEO=$1

docker run --rm -ti -v $(pwd):/opt -w /opt jrottenberg/ffmpeg:4.4-ubuntu -i "$VIDEO" -af "highpass=f=200,lowpass=f=5000,asetnsamples=480,astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.RMS_level" -f null /dev/null | grep 'lavfi.astats.Overall.RMS_level' | perl -p -e 's/.*RMS_level.//'
