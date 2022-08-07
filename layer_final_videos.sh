#!/bin/bash
FACEVIDEO=$1
SLIDEVIDEO=$2
OUT=$3

docker run -ti -v $(pwd):/opt -w /opt jrottenberg/ffmpeg:4.4-ubuntu \
  -y \
  -i "$FACEVIDEO" -i "$SLIDEVIDEO" -filter_complex \
 "[0:v]pad=1280:720:960:40:black[face]; \
  [1:v]scale=960:720[slide]; \
  [face][slide]overlay[out]" \
 -map "[out]" -map "0:a" -c:v h264 -c:a aac -strict -2 "$OUT"
