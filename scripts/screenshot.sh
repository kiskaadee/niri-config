#!/usr/bin/env bash

# -----------------------------------------------------
# Niri Screenshot Script (Rofi-based)
# -----------------------------------------------------

# Route configuration (ML4W compatible)
SAVE_DIR="~/Screenshots"
SAVE_FILENAME=$(cat ~/.config/ml4w/settings/screenshot-filename 2>/dev/null || echo "screenshot-$(date +%F_%T).png")
eval screenshot_folder="$SAVE_DIR"
NAME="$SAVE_FILENAME"

# initialize directory if needed
mkdir -p "$screenshot_folder"

# Rofi options
option_1="Immediate"
option_2="Delayed"
option_capture_1="Capture Everything"
option_capture_2="Capture Active Display"
option_capture_3="Capture Selection"
option_time_1="5s"; option_time_2="10s"; option_time_3="20s"

copy='Copy'; save='Save'; copy_save='Copy & Save'; edit='Edit'

rofi_cmd() {
    rofi -dmenu -replace -config ~/.config/rofi/config-screenshot.rasi -i -no-show-icons -p "$1"
}

# Niri capture logic - use built-in niri msg action
execute_niri_capture() {
    case "$option_type_screenshot" in
        "screen")  niri msg action screenshot-screen ;;
        "output")  niri msg action screenshot-screen ;; # Niri captures active monitor 
        "area")    niri msg action screenshot ;;        # interactve selection
    esac
}

# Timer
timer() {
    notify-send -t 1000 "Taking screenshot in $countdown seconds"
    sleep "$countdown"
}

# main action
takescreenshot() {
    sleep 0.2
    [[ -n "$countdown" ]] && timer
    execute_niri_capture
    notify-send -t 2000 "Niri Screenshot" "Capture triggered successfully"
}

# --- Rofi flow ---

# 1. Wait type 
chosen="$(echo -e "$option_1\n$option_2" | rofi_cmd "Mode")"
[[ "$chosen" == "$option_2" ]] && countdown=$(echo -e "$option_time_1\n$option_time_2\n$option_time_3" | rofi_cmd "Timer" | tr -d 's')

# 2. capture options 
selected_type=$(echo -e "$option_capture_1\n$option_capture_2\n$option_capture_3" | rofi_cmd "Type")
case "$selected_type" in
    "$option_capture_1") option_type_screenshot="screen" ;;
    "$option_capture_2") option_type_screenshot="output" ;;
    "$option_capture_3") option_type_screenshot="area" ;;
    *) exit 1 ;;
esac

takescreenshot
