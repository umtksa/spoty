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
  # Define an array to store your dictionary of URLs
  urls=(
    "OM=spotify:artist:4hCgC4FnYZLBgQPUMLOoiI"
    "Suburbs Of Goa=spotify:playlist:0zgFlKY9wUgVJZiCi3e7uf"
    "Bruce Menace=spotify:artist:5e8AoDvVcSuKM8GxPN3ub0"
    "Mono=spotify:artist:53LVoipNTQ4lvUSJ61XKU3"
    "Khuda=spotify:artist:2eGCa6T5v7c4vh2I3GgKux"
  )
  
  # Function to display choices
  display_choices() {
    for i in "${!urls[@]}"; do
      url_info="${urls[i]%%=*}"
      echo "[$i] $url_info"
    done
  }
  
  # Display choices
  display_choices

  # Read user input
  read -p "" choice
 
  # Play selected playlist
  if [[ $choice =~ ^[0-9]+$ && $choice -lt ${#urls[@]} ]]; then
    url_info="${urls[choice]%%=*}"
    selected_url="${urls[choice]#*=}"
    clear
    osascript -e '
    tell application "Spotify"
      play track "'"$selected_url"'"
    end tell
    '
  else
    echo "Invalid choice."
  fi
fi
