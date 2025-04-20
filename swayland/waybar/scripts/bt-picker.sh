#!/bin/bash

devices=$(bluetoothctl paired-devices | awk '{print $2 " " substr($0, index($0,$3))}')

selection=$(echo "$devices" | wofi --dmenu --prompt="Bluetooth Devices")

mac=$(echo "$selection" | awk '{print $1}')

if [ -n "$mac" ]; then
  bluetoothctl connect "$mac"
fi

