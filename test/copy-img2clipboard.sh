#!/usr/bin/env bash

on_mac(){
  osascript \
    -e 'on run args' \
    -e 'set the clipboard to POSIX file (first item of args)' \
    -e end \
    "$@"
}

case "$(uname)" in
  Darwin) on_mac "$1" ;;
  Linux)
    case "$XDG_SESSION_TYPE" in
      wayland) wl-copy < ./test/expected.png ;;
      x11|tty) xclip -selection clipboard -target image/png -i < ./test/expected.png
    esac
    ;;
  *) echo "Test can only run on macos/wayland for now"; exit 1;;
esac
