#!/bin/bash
# Made by CrazyCloudCraft 08.12.2021
# Configuration:
# Set your server path. Where is your paper.jar?
MPATH=/opt/Paper
#
# What jar and screen name does your Minecraft Server have?
MCNAME=paper
#
# Tranzlation:
MTRANZLATION=The server is not running. Starting server.
#


# Script start. Do not configure this!
if ! screen -list | grep -q "$MCNAME "; then
    echo "$MTRANZLATION"
    # Start server
    /bin/bash $MPATH/start.sh
    exit 0
fi

# Stop server
/bin/bash $MPATH/stop.sh

# Start server
/bin/bash $MPATH/start.sh