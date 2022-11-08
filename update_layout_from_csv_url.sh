#!/bin/bash
URL=$1

TMPFILE=$(mktemp ./tmp-XXXXXX);

curl -s -L "$URL" > "$TMPFILE"
docker run --rm -ti -v $(pwd):/opt -w /opt node:18 /bin/bash -c 'npm i csvtojson > /dev/null 2>&1; cat "'"$TMPFILE"'" | npx csvtojson' > layout.json

rm "$TMPFILE"
