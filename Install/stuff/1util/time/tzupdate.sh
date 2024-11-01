#!/bin/sh

if pgrep -x "openvpn" > /dev/null; then
	exit 0
fi

TZ=$(curl -s http://ip-api.com/json | jq -r .timezone)

if [ "$TZ" == "null" ]; then
	exit 0
fi
doas timedatectl set-timezone "$TZ"