#!/usr/bin/env bash
# Grab and record contents of the X11 display.

ffmpeg -f x11grab -s wxga -r 25 -i $DISPLAY -qscale 0 $(date +%s).mpg
