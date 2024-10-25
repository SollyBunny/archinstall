#!/bin/sh

temp=$(mktemp)
touch temp
cloudflared access tcp --hostname toshibasrv.sollybunny.xyz --url 127.0.0.1:9210 > "$temp" 2>&1 &
pid=$!

cleanup() {
    kill -9 "$pid" 2>/dev/null
    rm -f "$temp" 2>/dev/null
}

trap cleanup INT TERM

if [ -s "$temp" ] || timeout 2 tail -f "$temp" | grep .; then
    rm -f "$temp" 2>/dev/null
	ssh toshibasrv@localhost -p 9210
fi

cleanup
