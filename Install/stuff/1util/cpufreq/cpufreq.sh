#!/bin/sh

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <GHz>"
    exit 1
fi

# Convert the argument to KHz
frequency=$(echo "$1 * 1000000" | bc)

# Set CPU frequency
if sudo cpupower frequency-set -u "$frequency" > /dev/null 2>&1; then
    echo "CPU max frequency set to $1 GHz"
else
    echo "Failed"
    exit $?
fi
