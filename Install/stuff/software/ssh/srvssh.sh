#!/bin/sh

# Check if exactly one argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 [endpoint]"
    exit 1
fi

# Get the endpoint argument
endpoint="$1"
script_path="/etc/srvssh/$endpoint.sh"

# Check if the script exists
if [ ! -f "$script_path" ]; then
    echo "The script for endpoint '$endpoint' does not exist."
    echo "Valid endpoints are:"
    cd /etc/srvssh/
    ls *.sh | sed 's/\.sh$//g'
    exit 1
fi

# Run the script
sh "$script_path"
