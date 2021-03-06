#!/bin/bash
# Minecraft Server auto stop script - Do not configure this scipt!!
# Version 2.5.2.2 made by CrazyCloudCraft 2022-06-10 UTC/GMT +1 https://crazycloudcraft.de
OPTBASE=
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
