#!/bin/bash
VIDEO=$1

docker run -ti -v $(pwd):/opt -w /opt jrottenberg/ffmpeg:4.4-ubuntu -i "$VIDEO" 2>&1 | grep Duration|perl -pe 's/.*Duration: (.*?),.*/$1/; my ($h,$m,$s)=split(":",$_); $_=1000*(3600*$h+60*$m+$s)'
