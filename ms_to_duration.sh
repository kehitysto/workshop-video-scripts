#!/bin/bash
MS=$1
perl -e 'print int($ARGV[0]/1000/60/60) .":". int($ARGV[0]/1000/60)%60 .":". int($ARGV[0]%60000)/1000' "$MS"
