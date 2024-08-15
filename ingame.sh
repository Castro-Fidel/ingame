#!/usr/bin/env bash

if [[ "$(id -u)" == "0" ]] ; then
    echo "Do not run the script from the superuser!"
    exit 1
fi

INGAME_PATH="$(dirname "$(readlink -f "$0")")"

if [[ -f "$INGAME_PATH/ingame/main.py" ]] ; then
    echo "Used INGAME git version."
    python3 "$INGAME_PATH/ingame/main.py" $@ | tee "$HOME/.ingame.log"
elif [[ "$INGAME_PATH" =~ "/usr/bin" ]] ; then
    echo "Used INGAME native version."
    python3 "/usr/share/ingame/main.py" $@ | tee "$HOME/.ingame.log"
fi

exit 0
