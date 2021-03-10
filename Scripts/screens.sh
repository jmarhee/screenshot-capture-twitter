#!/bin/bash

if [ -z "${LNVC_DATA_PATH}" ]; then
    echo "No source path found." ; exit 1
fi

if [ -z "${LNVC_PREV_PATH}" ]; then
    echo "No target path found." ; exit 1
fi

if [ -n "${REFRESH_SCREENS}" ]; then
    rm -rf $LNVC_PREV_PATH/*.jpg
fi

for v in `ls $LNVC_DATA_PATH`; do \
    if [ -n "${DUMP_RANDOM}" ]; then 
        LENGTH=$(ffmpeg -i $LNVC_DATA_PATH/$v 2>&1 | grep Duration | cut -d ' ' -f 4 | sed s/,//) ; \
        HOUR=$(echo $((0 + RANDOM % $(echo $LENGTH | cut -d ":" -f 2)))) ; \
        if (( $HOUR < 10 )); then HOUR=$(printf "%02d\n" $HOUR); fi ; \
        MINUTE=$(echo $((1 + RANDOM % $(echo $LENGTH | cut -d ":" -f 2)))) ; \
        if (( $MINUTE < 10 )); then MINUTE=$(printf "%02d\n" $MINUTE); fi ; \
        SECOND=$(echo $((1 + RANDOM % 59))) ; \
        if (( $SECOND < 10 )); then SECOND=$(printf "%02d\n" $SECOND); fi ; \
        ffmpeg -i $LNVC_DATA_PATH/$v -ss $HOUR:$MINUTE:$SECOND.000 -vframes 1 $LNVC_PREV_PATH/`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''`.jpg
    fi
    
    if [ -n "${DUMP_INTERVAL}" ]; then
        ffmpeg -i $LNVC_DATA_PATH/$v -vf fps=1/$DUMP_INTERVAL $LNVC_PREV_PATH/`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''`.jpg
        # The filenames will be prefixed by a random string, but per-video; if you'd like them randomized in totality, set `RANDOMIZE_NAMES`
        if [ -n "${RANDOMIZE_NAMES}" ]; then
            cd $LNVC_PREV_PATH ; \
            for f in `ls`; do mv $f `head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''`.jpg; done
        fi
    fi
done
