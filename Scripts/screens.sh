#!/bin/bash

if [ -z "${LNVC_DATA_PATH}" ]; then
    echo "No source path found." ; exit 1
fi

if [ -z "${LNVC_PREV_PATH}" ]; then
    echo "No target path found." ; exit 1
fi

MINUTE=$(echo $((10 + RANDOM % 40)))
SECOND=$(echo $((10 + RANDOM % 59)))

if [ -n "${REFRESH_SCREENS}" ]; then
    rm -rf LNVC_PREV_PATH/*.jpg
fi

for v in `ls $LNVC_DATA_PATH`; do ffmpeg -i $LNVC_DATA_PATH/$v -ss 00:$MINUTE:$SECOND.000 -vframes 1 $LNVC_PREV_PATH/`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''`.jpg ; done
