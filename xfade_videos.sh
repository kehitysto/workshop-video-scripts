#!/bin/bash
VIDEO1=$1
VIDEO2=$2
FADEMS=$3
TRANSITION=$4
OUT=$5

DURMS=$(workshop-video-scripts/output_video_duration_ms.sh "$VIDEO1")
OFFSETMS=$(expr "$DURMS" - "$FADEMS")
OFFSET=$(workshop-video-scripts/ms_to_seconds.sh "$OFFSETMS")
DURATION=$(workshop-video-scripts/ms_to_seconds.sh "$FADEMS")

ATRACK=$(workshop-video-scripts/check_audio_track_exists.sh "$VIDEO1")

if [ "$ATRACK" == "true" ]; then
  ACROSSFADEFILTER="; acrossfade=d=$DURATION"
else
  ACROSSFADEFILTER=""
fi

docker run -ti -v $(pwd):/opt -w /opt jrottenberg/ffmpeg:4.4-ubuntu -y -i "$VIDEO1" -i "$VIDEO2" -filter_complex "[0][1]xfade=transition=$TRANSITION:duration=$DURATION:offset=$OFFSET$ACROSSFADEFILTER" -c:v ffv1 -c:a flac "$OUT"
