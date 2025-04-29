#!/bin/bash

echo "install important packages"

sudo apt install zsh vim screen tmux sudo git tree kitty alacritty curl wget \
fonts-dejavu-core fonts-dejavu-mono fonts-powerline

echo "intall additional stuff"
sudo apt install -y ipcalc nmap tcpdump dnsutils netcat telnet \
unzip dmarc-cat rdesktop remmina \ 
pipx rsync sysstat zip unzip yt-dlp \ 
openvpn wireguard xorriso chromium

echo "Later install this stuff"
echo "google-chrome oh-my-zsh"
echo "terraform packer vault awscli vscode docker drawing gthumb"

