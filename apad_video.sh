#!/bin/bash
VIDEO=$1
OUT=$2

DURMS=$(workshop-video-scripts/output_video_duration_ms.sh "$VIDEO")
DURS=$(workshop-video-scripts/ms_to_seconds.sh "$DURMS")

docker run --rm -ti -v $(pwd):/opt -w /opt jrottenberg/ffmpeg:4.4-ubuntu -y -i "$VIDEO" -filter_complex "[0:a]apad" -c:v copy -c:a flac -t "$DURS" "$OUT"

