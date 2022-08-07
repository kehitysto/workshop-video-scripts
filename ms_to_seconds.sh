#!/bin/bash
MS=$1
echo "$MS" | perl -pe '$_=$_/1000'