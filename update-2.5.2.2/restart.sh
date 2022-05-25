#!/bin/bash
# Made by CrazyCloudCraft
# Update v2.5.2.2 on 25.05.2022 made by Argantiu

# Do you have a Subfolder for your server(s)? We recommend to set and use one.
# E.g. home/server/(serverbase) or opt/(serverbase)
OPTBASE=
# Set your server folder, where your server shall run (serverbase).
SERVERBASE=

# Build path
LPATH=/$OPTBASE/$SERVERBASE

# Check if offline
if ! screen -list | grep -q "$MCNAME"; then
    echo -e "The server is not running. Starting server."
    # Start server
    /bin/bash $LPATH/start.sh
    exit 0
fi

# Stop server
/bin/bash $LPATH/stop.sh

# Start server
/bin/bash $LPATH/start.sh
