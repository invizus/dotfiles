#!/bin/bash

USER_NAME=$(logname)
USER_HOME="/home/$USER_NAME"

echo ">>> Updating package list..."
apt update

echo ">>> Installing core packages..."
apt install -y \
  sway swayidle swaylock \
  waybar foot wofi \
  wl-clipboard grim slurp kanshi \
  cliphist seatd dbus-user-session \
  xdg-desktop-portal-wlr \
  pamixer mako-notifier \
  fonts-firacode fonts-font-awesome \
  fonts-noto fonts-noto-color-emoji \
  fonts-dejavu-core fonts-dejavu fonts-noto-mono \
  blueman wlogout curl wget

echo ">>> Removing xwayland if present..."
apt remove -y xwayland || true

echo ">>> Adding user to input, video, seat groups..."
usermod -aG input,video,seat "$USER_NAME"

echo ">>> Creating configs..."
mkdir -p "$USER_HOME/.config/sway"
mkdir -p "$USER_HOME/.config/waybar/scripts"

curl -L "https://raw.githubusercontent.com/invizus/dotfiles/refs/heads/master/swayland/sway/config" -o "$USER_HOME/.config/sway/config"
curl -L "https://raw.githubusercontent.com/invizus/dotfiles/refs/heads/master/swayland/waybar/config" -o "$USER_HOME/.config/waybar/config"
curl -L "https://raw.githubusercontent.com/invizus/dotfiles/refs/heads/master/swayland/waybar/style.css" -o "$USER_HOME/.config/waybar/style.css"
curl -L "https://raw.githubusercontent.com/invizus/dotfiles/refs/heads/master/swayland/waybar/scripts/bt-picker.sh" -o "$USER_HOME/.config/waybar/scripts/bt-picker.sh"
chmod +x "$USER_HOME/.config/waybar/scripts/bt-picker.sh"

chown -R "$USER_NAME:$USER_NAME" "$USER_HOME/.config"

echo ">>> Setup complete! Please reboot."

