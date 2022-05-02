#!/bin/bash
# Made by CrazyCloudCraft
# Update v2.5.1.1 on 24.04.2022

# Configuration:
# Set your server path. Where is your paper.jar?
MPATH=Paper
# Where are your servers in (like home or opt directory)
OPATH=opt
# What jar and screen name does your Minecraft server have?
MCNAME=paper
# Tranzlation:
MTRANZLATION="The server is not running. Starting server."


# Script start. Do not configure this! #############################################

# Build path
CXPATH=/$OPATH/$MPATH

# Check if offline
if ! screen -list | grep -q "$MCNAME"; then
    echo -e "\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m $MTRANZLATION"
    # Start server
    /bin/bash $CXPATH/start.sh
    exit 0
fi

# Stop server
/bin/bash $CXPATH/stop.sh

# Start server
/bin/bash $CXPATH/start.sh