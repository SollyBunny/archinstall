#!/bin/sh

chromium --enable-features=UseOzonePlatform --ozone-platform=$XDG_SESSION_TYPE $@
