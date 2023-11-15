#!/bin/bash

# Function to display usage information
display_usage() {
  echo "Usage: [-p] [-n] [-v <volume_level>] [-h]"
  echo "run without arguments to get playlist suggestions to play"
  echo "  -p         Play/Pause Spotify"
  echo "  -n         Play the next track in Spotify"
  echo "  -v <level> Set the volume in Spotify (0-100)"
  echo "  -h         Display this help message"
}

# Check if the file exists and is readable
file="playlist.txt"
if [ ! -r "$file" ]; then
  echo "Error: $file does not exist or is not readable."
  exit 1
fi

# Read URLs from the file, sort alphabetically, and populate the array
IFS=$'\n' read -r -d '' -a urls < <(sort -f "$file" | awk -F '=' '{print $1}')

while getopts ":pnv:h" opt; do
  case $opt in
    p)
      osascript -e '
      tell application "Spotify"
        playpause
      end tell
      '
      ;;
    n)
      osascript -e '
      tell application "Spotify"
        next track
      end tell
      '
      ;;
    v)
      # Check if the argument is a valid integer
      if [[ $OPTARG =~ ^[0-9]+$ ]]; then
        volume_level=$OPTARG
        osascript -e '
        tell application "Spotify"
          set sound volume to '$volume_level'
        end tell
        '
      else
        echo "Invalid volume argument. Please specify an integer."
        exit 1
      fi
      ;;
    h)
      display_usage
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      exit 1
      ;;
  esac
done

# If no options were provided or after processing the options
if [[ $OPTIND -eq 1 ]]; then
  # Function to display sorted choices using fzf
  display_choices() {
    for entry in "${urls[@]}"; do
      echo "$entry" | cut -d '=' -f 1
    done | fzf --prompt="Choose one: " --preview="echo {1}" --preview-window=up:3:hidden
  }

  # Display sorted choices and store the selected playlist key
  selected_key=$(display_choices)

  # Play selected playlist
  if [ -n "$selected_key" ]; then
    for entry in "${urls[@]}"; do
      key="${entry%%=*}"
      if [ "$key" == "$selected_key" ]; then
        selected_url="${entry#*=}"
        break
      fi
    done
    clear
    osascript -e '
    tell application "Spotify"
      play track "'"$selected_url"'"
    end tell
    '
  else
    echo "No selection made."
  fi
fi
