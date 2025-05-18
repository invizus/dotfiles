#!/bin/bash

# Check if blueman-applet is already running
if ! pgrep -x "blueman-applet" > /dev/null; then
    blueman-applet &
    # Give it a moment to initialize
    sleep 1
fi

# Now launch blueman-manager
blueman-manager

