#!/bin/bash
VIDEO=$1
STARTBUFFMS=$2
STOPBUFFMS=$3
OUT=$4

REALSTARTMS=$(workshop-video-scripts/output_audio_start_ms.sh "$VIDEO")
REALSTOPMS=$(workshop-video-scripts/output_audio_stop_ms.sh "$VIDEO")

STARTMS=$(expr $REALSTARTMS - $STARTBUFFMS)
STOPMS=$(expr $REALSTOPMS + $STOPBUFFMS)

workshop-video-scripts/crop_video_ms_to_ms.sh "$VIDEO" "$STARTMS" "$STOPMS" "$OUT"

