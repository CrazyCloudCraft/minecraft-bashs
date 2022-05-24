#!/bin/bash
# Minecraft Server start script - Check if server is already started
# Version 2.5 made by CrazyCloudCraft 03.04.2022 UTC/GMT +1 https://crazycloudcraft.de
# Version 2.5.1 made by CrazyCloudCraft 09.04.2022 UTC/GMT +1 https://crazycloudcraft.de

# Configuration:
# Define your Minecraft version like 1.18.2 based on your Software
# For Velocity you set the latest PROXY version ( in the moment: 3.1.2 (just look on https://papermc.io/downloads#Velocity )
MAINVERSION=1.18.2
# What type of Server Software do you use? 
# You can use: PAPER, PURPUR, MOHIST, VELOCITY, BUNGEECORD 
ASOFTWARE=BUNGEECORD
# Set your folder where the subfolders of your server shall run
OPTBASE=opt
# Set your server folder where your server shall run
SERVERBASE=Server
# Backups go here underneath BPATH
BPATH=Server_backups
# Do you need a Backup ? BACKUP=TRUE
BACKUP=FALSE
# What jar and screen name shall your Minecraft server have?
MCNAME=server
# Amount of RAM that your Mincecraft server will use (M or G) e.g.: RAM=2024M or RAM=10G
RAM=500M
# Name of your java executable (Default java) e.g.: JAVABIN=/usr/bin/java
JAVABIN=java17

# --- Bedrock Edition (MCPE) ---

# Get Floodgate updater? Otherwise nobody can join without Java Edition account from Bedrock.
BEUPDATE=FALSE
# Geyser too? Because you didn't need it, if this server is connected with a proxy.
GBESUPPORT=FALSE

# Script start: Do not change after here ###############################################

# Your local absolute path
LPATH=/$OPTBASE/$SERVERBASE
mkdir -p $LPATH

#Install depencies
touch $MCNAME.jar
mkdir -p $LPATH/jar
mkdir -p $LPATH/unused 
#
 if ! command -v joe &> /dev/null
 then
     apt-get install joe -y
     echo "joe installed"
 fi
#
 if ! command -v screen &> /dev/null
 then
     apt-get install screen -y
     echo "screen installed"
 fi
#
 if ! command -v sudo &> /dev/null
 then
     apt-get install sudo -y
     echo "sudo installed"
 fi
#
 if ! command -v zip &> /dev/null
 then
     apt-get install zip -y
     echo "zip installed"
 fi
#
 if ! command -v wget &> /dev/null
 then
     apt-get install wget -y
     echo "wget installed"
 fi
#
 if ! command -v xargs &> /dev/null
 then
     apt-get install findutils -y
     echo "findutils installed"
 fi
#
 if ! command -v diff &> /dev/null
 then
     apt-get install diffutils -y
     echo "diffutils installed"
 fi
#
 if ! command -v rpl &> /dev/null
 then
     apt-get install rpl -y
     echo "rpl installed"
 fi 
#Testing Dependencies
rpl -quiet "eula=false" "eula=true" eula.txt >/dev/null 2>&1

#Testing Dependencies 2
if screen -list | grep -q "$MCNAME "; then
    echo "Server has already started! Use screen -r $MCNAME to open it"
    exit 1
fi

# Change directory to server directory
cd $LPATH

# Create backup for your server
if [ $BACKUP = "TRUE" ]; then
 if [ -f "$MCNAME.jar" ]; then
    echo "Backing up server (to /$OPTBASE/$BPATH folder)" | /usr/bin/logger -t $MCNAME
    cd /$OPTBASE/$BPATH && ls -1tr | head -n -10 | xargs -d '\n' rm -f --
    cd $LPATH
    tar -pzcf ../$BPATH/$(date +%Y.%m.%d.%H.%M.%S).tar.gz --exclude='FaWeSnapshots/*' --exclude='unused/*' ./
 fi
fi

# Clean Logfiles
/usr/bin/find $LPATH/logs -type f -mtime +6 -delete > /dev/null 2>&1

#Paper: Getting Update form your selected version.
