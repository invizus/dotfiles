#!/bin/bash

status=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

volume=$(echo "$status" | awk '{printf "%.0f", $2 * 100}')

if echo "$status" | grep -q MUTED; then
    echo "{\"text\": \" $volume\", \"class\": \"muted\"}"
else
    echo "{\"text\": \" $volume\", \"class\": \"normal\"}"
fi

