#!/bin/bash
SECTION=$1

mkdir -p out-parts

OUTVID=out-parts/"$SECTION".mkv
TMPOUTVID=out-parts/raw-speaker-"$SECTION".mkv
TMPOUTVIDAPAD="$TMPOUTVID".apadded.mkv

TMPOUTSLI=out-parts/raw-slide-"$SECTION".mkv

PART=0
while [ 1 ]; do
  RB=$(workshop-video-scripts/pick_section_part_attribute.sh $SECTION $PART resource_base)
  if [ "$RB" == "" ]; then break; fi
  #if [ "$PART" == 3 ]; then break; fi

  echo 'Processing '"$SECTION"' part '$PART': '"$RB"

  SPEAKER=$(workshop-video-scripts/pick_section_part_attribute.sh $SECTION $PART speaker)
  BEFOREMS=$(workshop-video-scripts/pick_section_part_attribute.sh $SECTION $PART beforems)
  AFTERMS=$(workshop-video-scripts/pick_section_part_attribute.sh $SECTION $PART afterms)

  OUTPARTTRIM=out-parts/speaker-"$RB"-trimmed.mkv
  OUTPARTCROP=out-parts/speaker-"$RB"-cropped.mkv
  OUTPARTAPAD=out-parts/speaker-"$RB"-apadded.mkv
  OUTPARTSLI=out-parts/speaker-"$RB"-slide.mkv

  if [ ! -f "$OUTPARTTRIM" ]; then
    echo "Trimming video to: $OUTPARTTRIM"
    workshop-video-scripts/trim_video_by_audio.sh videos-"$SPEAKER"/"$RB".mkv "$BEFOREMS" "$AFTERMS" "$OUTPARTTRIM"
  else
    echo "Trimming skipped because found: $OUTPARTTRIM"
  fi

  if [ ! -f "$OUTPARTCROP" ]; then
    echo "Cropping video to: $OUTPARTCROP"
    workshop-video-scripts/crop_video_sides_to_w_h.sh "$OUTPARTTRIM" 320 640 "$OUTPARTCROP"
  else
    echo "Cropping skipped because found: $OUTPARTCROP"
  fi

  if [ ! -f "$OUTPARTAPAD" ]; then
    echo "Apadding video to: $OUTPARTAPAD"
    workshop-video-scripts/apad_video.sh "$OUTPARTCROP" "$OUTPARTAPAD"
  else
    echo "Apadding skipped because found: $OUTPARTAPAD"
  fi

  if [ ! -f "$OUTPARTSLI" ]; then
    echo "Preparing slide video to: $OUTPARTSLI"

    DURMS=$(workshop-video-scripts/output_video_duration_ms.sh "$OUTPARTAPAD")
    DURS=$(workshop-video-scripts/ms_to_seconds.sh "$DURMS")

    echo $DURS

    docker run --rm -ti -v $(pwd):/opt -w /opt jrottenberg/ffmpeg:4.4-ubuntu -y -loop 1 -framerate 30 -i slides/"$RB".png -t "$DURS" -pix_fmt yuv420p -vf scale=960:720  -c:v ffv1 "$OUTPARTSLI"
  else
    echo "Preparing slide skipped because found: $OUTPARTSLI"
  fi

  if [ $PART == 0 ]; then
    if [ -f "$TMPOUTVID" ]; then
      rm -f "$TMPOUTVID"
      echo "skipping face video generation"
    fi
    if [ -f "$TMPOUTSLI" ]; then
      rm -f "$TMPOUTSLI"
    fi

    cp "$OUTPARTAPAD" "$TMPOUTVID"
    cp "$OUTPARTSLI" "$TMPOUTSLI"
  else
    workshop-video-scripts/append_video_to_temp_video.sh "$OUTPARTAPAD" "$TMPOUTVID" 500 smoothup
    workshop-video-scripts/apad_video.sh "$TMPOUTVID" "$TMPOUTVIDAPAD"
    mv -f "$TMPOUTVIDAPAD" "$TMPOUTVID"

    workshop-video-scripts/append_video_to_temp_video.sh "$OUTPARTSLI" "$TMPOUTSLI" 500 smoothdown
  fi

  ((PART++))
done;

workshop-video-scripts/layer_final_videos.sh "$TMPOUTVID" "$TMPOUTSLI" "$OUTVID"
