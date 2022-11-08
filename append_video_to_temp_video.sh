#!/bin/bash
VIDEO1=$1
VIDEO2=$2
FADEMS=$3
TRANSITION=$4
TMPOUT="$VIDEO2.appended.ffv1.mkv"

workshop-video-scripts/xfade_videos.sh "$VIDEO2" "$VIDEO1" "$FADEMS" "$TRANSITION" "$TMPOUT"
mv -f "$TMPOUT" "$VIDEO2"
