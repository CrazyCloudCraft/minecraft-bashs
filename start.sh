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
if [ $ASOFTWARE = "PAPER" ]; then
 cd $LPATH/jar
 rm -f version.json
 wget -q https://papermc.io/api/v2/projects/paper/versions/$MAINVERSION/ -O version.json
 LATEST=`cat version.json | jq -r ".builds" | grep -v "," | grep -e "[0-9]" | tr -d " "`
 wget -q https://papermc.io/api/v2/projects/paper/versions/$MAINVERSION/builds/$LATEST/downloads/$MCNAME-$MAINVERSION-$LATEST.jar
 unzip -qq -t paper-$MAINVERSION-$LATEST.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded paper-$MAINVERSION-$LATEST.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  diff -q paper-$MAINVERSION-$LATEST.jar ../$MCNAME.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   /usr/bin/find $LPATH/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   cp paper-$MAINVERSION-$LATEST.jar paper-$MAINVERSION-$LATEST.jar.$(date +%Y.%m.%d.%H.%M.%S)
   mv paper-$MAINVERSION-$LATEST.jar $LPATH/$MCNAME.jar
   echo "paper-$MAINVERSION-$LATEST has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No paper-$MAINVERSION-$LATEST update neccessary" | /usr/bin/logger -t $MCNAME
   rm paper-$MAINVERSION-$LATEST.jar
   rm version.json
  fi
 fi
fi

#PurPur: Getting Update form your selected version.
if [ $ASOFTWARE = "PURPUR" ]; then
 cd $LPATH/jar
 rm -f version.json
 wget -q https://api.purpurmc.org/v2/purpur/$MAINVERSION -O version.json
 LATEST=`cat version.json | jq -r ".builds" | grep -v "," | grep -v ":" | grep -e "[0-9]" | cut -d "\"" -f2`
 wget -q https://api.purpurmc.org/v2/purpur/$MAINVERSION/$LATEST/download -O purpur-$MAINVERSION-$LATEST.jar
 unzip -qq -t purpur-$MAINVERSION-$LATEST.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded purpur-$MAINVERSION-$LATEST.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  diff -q purpur-$MAINVERSION-$LATEST.jar ../$MCNAME.jar >/dev/null 2>&1 
  if [ "$?" -eq 1 ]; then
   /usr/bin/find $LPATH/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   cp purpur-$MAINVERSION-$LATEST.jar purpur-$MAINVERSION-$LATEST.jar.$(date +%Y.%m.%d.%H.%M.%S)
   mv purpur-$MAINVERSION-$LATEST.jar $LPATH/$MCNAME.jar
   echo "purpur-$MAINVERSION-$LATEST has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No purpur-$MAINVERSION-$LATEST update neccessary" | /usr/bin/logger -t $MCNAME
   rm purpur-$MAINVERSION-$LATEST.jar
   rm version.json
  fi
 fi
fi
#Mohist: Getting Update form your selected version.
if [ $ASOFTWARE = "MOHIST" ]; then
 cd $LPATH/jar
 DATE=$(date +%Y.%m.%d.%H.%M.%S)
 wget -q https://mohistmc.com/api/$MAINVERSION/latest/download -O mohist-$MAINVERSION-$DATE.jar
 unzip -qq -t  mohist-$MAINVERSION-$DATE.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded mohist-$MAINVERSION-$DATE.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  diff -q mohist-$MAINVERSION-$DATE.jar ../$MCNAME.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   /usr/bin/find $LPATH/jar/* -type f -mtime +30 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   cp mohist-$MAINVERSION-$DATE.jar  mohist-$MAINVERSION-$DATE.jar.backup
   mv mohist-$MAINVERSION-$DATE.jar $LPATH/$MCNAME.jar
   echo "mohist-$MAINVERSION-$DATE.jar has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No mohist-$MAINVERSION-$DATE.jar update neccessary" | /usr/bin/logger -t $MCNAME
   rm mohist-$MAINVERSION-$DATE.jar
  fi
 fi
fi

#Velocity: Getting Update form your selected version.
if [ $ASOFTWARE = "VELOCITY" ]; then
 cd $LPATH/jar
 rm -f version.json
 wget -q https://papermc.io/api/v2/projects/velocity/versions/$MAINVERSION-SNAPSHOT -O version.json
 LATEST=`cat version.json | jq -r ".builds" | grep -v "," | grep -e "[0-9]" | tr -d " "`
 wget -q https://papermc.io/api/v2/projects/velocity/versions/$MAINVERSION-SNAPSHOT/builds/$LATEST/downloads/velocity-$MAINVERSION-SNAPSHOT-$LATEST.jar
 unzip -qq -t velocity-$MAINVERSION-SNAPSHOT-$LATEST.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded velocity-$MAINVERSION-SNAPSHOT-$LATEST.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  diff -q velocity-$MAINVERSION-SNAPSHOT-$LATEST.jar ../$MCNAME.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   /usr/bin/find $LPATH/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   cp velocity-$MAINVERSION-SNAPSHOT-$LATEST.jar velocity-$MAINVERSION-SNAPSHOT-$LATEST.jar.$(date +%Y.%m.%d.%H.%M.%S)
   mv velocity-$MAINVERSION-SNAPSHOT-$LATEST.jar $LPATH/$MCNAME.jar
   echo "velocity-$MAINVERSION-SNAPSHOT-$LATEST has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No velocity-$MAINVERSION-SNAPSHOT-$LATEST update neccessary" | /usr/bin/logger -t $MCNAME
   rm velocity-$MAINVERSION-SNAPSHOT-$LATEST.jar
   rm version.json
  fi
 fi
fi

#Bungeecord: Getting Update form your selected version.
if [ $ASOFTWARE = "BUNGEECORD" ]; then
 cd $LPATH/jar
 rm -f version.json
 wget -q https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar
 unzip -qq -t BungeeCord.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded BungeeCord.jar No update." | /usr/bin/logger -t $MCNAME
 else
  diff -q BungeeCord.jar ../$MCNAME.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   /usr/bin/find $LPATH/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   cp BungeeCord.jar BungeeCord.jar.$(date +%Y.%m.%d.%H.%M.%S)
   mv BungeeCord.jar $LPATH/$MCNAME.jar
   echo "BungeeCord.jar has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No BungeeCord.jar update neccessary" | /usr/bin/logger -t $MCNAME
   rm BungeeCord.jar
   rm -f version.json
  fi
 fi
fi 
# Bedrock edition

mkdir -p $LPATH/plugins
mkdir -p $LPATH/mcsys

# Floodgate for Spigot
if [ $ASOFTWARE = "PAPER" ] || [ $ASOFTWARE = "SPIGOT" ] || [ $ASOFTWARE = "BUKKIT" ] || [ $ASOFTWARE = "PURPUR" ] && [ $BESUPPORT = "TRUE" ]; then
 cd $LPATH/plugins || exit 1
 mkdir -p $LPATH/mcsys/floodgate
 cd $LPATH/mcsys/floodgate || exit 1
 wget -q https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/spigot/target/floodgate-spigot.jar -O floodgate-spigot.jar
 unzip -qq -t floodgate-spigot.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded floodgate default is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  if [ -f $LPATH/plugins/floodgate-spigot.jar ]; then
   echo "Floodgate plugin exists" | /usr/bin/logger -t $MCNAME
  else
   touch $LPATH/plugins/floodgate-spigot.jar 
  fi
  diff -q floodgate-spigot.jar $LPATH/plugins/floodgate-spigot.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   cp floodgate-spigot.jar floodgate-spigot.jar."$(date +%Y.%m.%d.%H.%M.%S)"
   mv floodgate-spigot.jar $LPATH/plugins/floodgate-spigot.jar
   /usr/bin/find $LPATH/mcsys/floodgate/* -type f -mtime +6 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   echo "floodgate default has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No floodgate default update neccessary" | /usr/bin/logger -t $MCNAME
   rm floodgate-spigot.jar
  fi
 fi
fi
