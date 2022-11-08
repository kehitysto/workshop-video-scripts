#!/bin/bash
VIDEO=$1
W=$2
H=$3
OUT=$4

docker run --rm -ti -v $(pwd):/opt -w /opt jrottenberg/ffmpeg:4.4-ubuntu -y -i "$VIDEO" -vf "scale=-2:$H,crop=in_h*$W/$H:in_h:in_w/2-$W/2:0" -c:v ffv1 -c:a copy "$OUT"
