#!/bin/sh

# Function to get current brightness level
get_brightness() {
    for i in /sys/class/backlight/*; do
        local max_brightness=$(cat "$i/max_brightness")
        local current_brightness=$(cat "$i/brightness")
        local percentage=$(echo "scale=2; 100 * $current_brightness / $max_brightness" | bc)
        echo "$(basename "$i"): $percentage%"
    done
}

# Function to set brightness to a specified level
set_brightness() {
    local level=$1
    for i in /sys/class/backlight/*; do
        local max_brightness=$(cat "$i/max_brightness")
        # Calculate new brightness using bc for floating point precision
        local new_brightness=$(echo "$level * $max_brightness / 100" | bc)
        # Convert new_brightness to an integer
        new_brightness=$(printf "%.0f" "$new_brightness")
        echo $new_brightness | sudo tee "$i/brightness" > /dev/null
    done
}

# Function to adjust brightness by a relative amount
change_brightness() {
    local change=$1
    for i in /sys/class/backlight/*; do
        local max_brightness=$(cat "$i/max_brightness")
        local current_brightness=$(cat "$i/brightness")
        # Calculate new brightness with floating-point precision
        local new_brightness=$(echo "$current_brightness + $change * $max_brightness / 100" | bc)
        # Ensure brightness is within bounds [0, max_brightness]
        if (( $(echo "$new_brightness < 0" | bc -l) )); then
            new_brightness=0
        elif (( $(echo "$new_brightness > $max_brightness" | bc -l) )); then
            new_brightness=$max_brightness
        fi
        new_brightness=$(printf "%.0f" "$new_brightness")  # Convert to integer
        echo $new_brightness | sudo tee "$i/brightness" > /dev/null
    done
}

help() {
    echo "Usage: $0 [option]"
    echo "Options:"
    echo "  =[value]      : Set brightness to [value] percentage (e.g., =50)"
    echo "  +[value]      : Increase brightness by [value] percentage (e.g., +10)"
    echo "  -[value]      : Decrease brightness by [value] percentage (e.g., -10)"
    exit 1
}

if [ $# -eq 0 ]; then
    get_brightness
else
    case $1 in
        =*)
            set_brightness "${1:1}"
            ;;
        +*)
            change_brightness "${1:1}"
            ;;
        -*)
            change_brightness "${1}"
            ;;
        *)
            help
            ;;
    esac
fi
