#!/bin/bash

# Watch clipboard changes and clear after 60 seconds
wl-paste --watch --foreground --type text --no-newline --on-change \
'(
  sleep 300
  wl-copy -c
  cliphist wipe
)' &

