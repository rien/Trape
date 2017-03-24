#!/bin/bash
set -eo pipefail

aflevering_name="20170320_aflevering7.mp4"
playlist_url="http://vod.streamcloud.be/vier_vod/mp4:_definst_/demol/2017/volledigeafleveringen/$aflevering_name/playlist.m3u8"

function test {
    res=`curl -s -I $1 | grep HTTP/1.1 | awk {'print $2'}`
    if [ $res -ne 200 ]
    then
        echo "Error $res on $1"
    fi
}

function download {
    ffmpeg -i "$1" -c copy "$2"
}

function reschedule {
    at now + 5 minutes $1
}

if test $playlist_url; then
    download $playlist_url $aflevering_name
else
    reschedule $0
fi



download $playlist_url $aflevering_name


