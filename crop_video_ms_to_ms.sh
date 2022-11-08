#!/bin/bash
VIDEO=$1
STARTMS=$2
STOPMS=$3
OUT=$4

START=$(workshop-video-scripts/ms_to_duration.sh "$STARTMS")
STOP=$(workshop-video-scripts/ms_to_duration.sh "$STOPMS")

docker run --rm -ti -v $(pwd):/opt -w /opt jrottenberg/ffmpeg:4.4-ubuntu -y -i "$VIDEO" -ss "$START" -to "$STOP" -c:v ffv1 -c:a flac "$OUT"
