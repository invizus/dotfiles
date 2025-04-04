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
  greetd tuigreet \
  cliphist seatd dbus-user-session \
  xdg-desktop-portal-wlr \
  pamixer

echo ">>> Removing xwayland if present..."
apt remove -y xwayland || true

echo ">>> Adding user to input, video, seat groups..."
usermod -aG input,video,seat "$USER_NAME"

echo ">>> Enabling greetd..."
systemctl enable greetd

echo ">>> Writing greetd config..."
cat > /etc/greetd/config.toml <<EOF
[terminal]
vt = 1

[default_session]
command = "tuigreet --cmd sway --user-menu"
user = "_greetd"
EOF

echo ">>> Creating sway config..."
mkdir -p "$USER_HOME/.config/sway"
cat > "$USER_HOME/.config/sway/config" <<'EOF'
set $mod Mod4
font pango:monospace 10

exec_always swayidle -w \
  timeout 300 'swaylock -f -c 000000' \
  timeout 600 'swaymsg "output * dpms off"' \
  resume 'swaymsg "output * dpms on"' \
  before-sleep 'swaylock -f -c 000000'

exec_always waybar
exec_always wl-paste --watch cliphist store
exec_always kanshi

input * {
  xkb_layout us
  natural_scroll enabled
}

bindsym $mod+Return exec foot
bindsym $mod+d exec wofi --show drun
bindsym $mod+shift+q kill
bindsym $mod+shift+r reload
bindsym $mod+shift+e exit

bindsym $mod+Left focus left
bindsym $mod+Right focus right
bindsym $mod+Up focus up
bindsym $mod+Down focus down

output * bg /usr/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png fill
EOF

chown -R "$USER_NAME:$USER_NAME" "$USER_HOME/.config"

echo ">>> Setup complete! Reboot to launch Sway via greetd."

