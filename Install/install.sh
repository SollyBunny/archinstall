#!/bin/sh

if [ "$(id -u)" -ne 0 ]; then
	echo "This script must be run as root" >&2
	exit 1
fi

if ! command -v node &> /dev/null; then
	pacman -S --needed nodejs
fi

node ./install.js