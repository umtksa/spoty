# spoty
spotify cli minimal as can be 

controlling official spotify client in the background so you dont need an api key

Made this tool to control another mac over ssh that run spotify
calling Apple script to control Spotify.

edit the playlist inside the code or use spoty_fzf_playlist that uses external playlist.txt

```shell
"OM=spotify:artist:4hCgC4FnYZLBgQPUMLOoiI"
"Suburbs Of Goa=spotify:playlist:0zgFlKY9wUgVJZiCi3e7uf"
"Bruce Menace=spotify:artist:5e8AoDvVcSuKM8GxPN3ub0"
"Mono=spotify:artist:53LVoipNTQ4lvUSJ61XKU3"
"Khuda=spotify:artist:2eGCa6T5v7c4vh2I3GgKux"
```

Usage: spoty [-p] [-n] [-v <volume_level>] [-h]

run spoty without arguments to get playlist to play

spoty -p         Play/Pause Spotify"

spoty -n         Play the next track in Spotify"

spoty -v <level> Set the volume in Spotify (0-100)"

spoty -h         Display help message"

may not be the best but it works
