#!/bin/bash
SECTION=$1
PART=$2
ATTR=$3

docker run --rm -v $(pwd):/opt -w /opt node:18 -e 'var part = require("./sections.json").filter( r => r.output.toLowerCase() == "'"$SECTION"'".toLowerCase())['"$PART"']; console.log( part ? part["'"$ATTR"'"] : "")'

# this is much faster, so if you have node locally, comment avobe and uncomment this
#node -e 'var part = require("./sections.json").filter( r => r.output.toLowerCase() == "'"$SECTION"'".toLowerCase())['"$PART"']; console.log( part ? part["'"$ATTR"'"] : "")'


