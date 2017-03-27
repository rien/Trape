#!/bin/bash
set -eo pipefail

duration=30s
aflevering_name="20170327_aflevering8.mp4"
playlist_url="http://vod.streamcloud.be/vier_vod/mp4:_definst_/demol/2017/volledigeafleveringen/$aflevering_name/playlist.m3u8"

function test {
    res=$(curl -s -I $1 | grep HTTP/1.1 | awk {'print $2'})
    if [ $res -ne 200 ]
    then
        echo "Error $res on $1"
        return 1
    fi
}

function download {
    ffmpeg -i "$1" -c copy "$2"
}

function loop {
    while true; do
        echo
        echo "Is the episode online yet?"
        if test "$playlist_url"; then
            echo "Yes! downloading..."
            download "$playlist_url" "$aflevering_name"
            touch "$aflevering_name.downloaded"
            break
        else
            echo "Nothing found. Retrying in $duration"
            sleep "$duration"
        fi
    done
}

echo "Starting loop..."
loop

