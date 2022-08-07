#!/bin/bash
VIDEO=$1
STARTMS=$2
STOPMS=$3
OUT=$4

workshop-video-scripts/output_video_volumes.sh "$VIDEO" | perl -n -e '

BEGIN { my @input = () }

chomp $_;
push @input, $_;

END {
  my $sum100=0, $output="", $n=-1, $buffer=[], $bhit=0, $bmiss=0;

  for my $current (reverse @input) {
    $n++;
    if ( $n < 100 ) {
      $sum100 += $current;
    }
    else {
      if ( @$buffer >= 30 ) {
        if ( shift @$buffer ) { $bhit-- }
        else { $bmiss-- };
      }
      if ( $current > ( $sum100 / 100 ) + 5 ) {
        push @$buffer, 1;
        $bhit++;
      }
      else {
        push @$buffer, 0;
        $bmiss++;
      }
      if ( !$output && $buffer->[0] && $bhit > 25 ) {
        $output = ( $n - 30 ) * 10;
      }
    }
  }
  $output = $n * 10 - $output;

  print $output . "\n"
}
'
