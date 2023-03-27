# Plex Subtitle Copier
Plex won't find subtitle files in subdirectories, so I wrote this script to copy and rename subtitle files from a `Subs/` or `Subtitles/` subfolder into your main video folder.

https://user-images.githubusercontent.com/41765990/227842210-a2575d3d-4b08-490e-8fcf-e73c3291d8fa.mp4

# Installation
1. Clone the repo
2. Run `bundle install`

# Usage
Uhh run the script with Ruby, lol. Only tested on Linux/WSL but should work fine on MacOS. Unknown whether it'll work on a native Windows Ruby install.

A command line argument can be provided to specify the path to the folder where your video files are stored:

`ruby plex_subtitle_copier.rb ~/Videos/Deadwood/Season\ 1`

If the path isn't provided as a CLI argument then you'll be prompted for it when the script runs.

The folder is expected to contain a subdirectory called either `Subs/` or `Subtitles/`. If you have any other questions then read the source code, it's like 70 lines, lazybones. Or post an issue I guess. Contributions welcome, make a PR.
