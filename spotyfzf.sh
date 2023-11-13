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

# Your array of options
urls=(
    "OM=spotify:artist:4hCgC4FnYZLBgQPUMLOoiI"
    "Suburbs Of Goa=spotify:playlist:0zgFlKY9wUgVJZiCi3e7uf"
    "Bruce Menace=spotify:artist:5e8AoDvVcSuKM8GxPN3ub0"
    "Mono=spotify:artist:53LVoipNTQ4lvUSJ61XKU3"
    "Khuda=spotify:artist:2eGCa6T5v7c4vh2I3GgKux"
  )
  

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
  # Function to display choices using fzf
  display_choices() {
    for entry in "${urls[@]}"; do
      echo "$entry" | cut -d '=' -f 1
    done | fzf --prompt="Choose one: " --preview="echo {1}" --preview-window=up:3:hidden
  }

  # Display choices and store the selected playlist key
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
    echo "No playlist selected."
  fi
fi
