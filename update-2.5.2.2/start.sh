#!/bin/bash
# Minecraft Server start script - Check if server is already started

# THIS IS THE LAST VERSION OF minecraft-bashs. The new server-manager system that we support, is now here: https://github.com/Argantiu/system-api

# Version 2.5.2.2 made by CrazyCloudCraft 25.05.2022 UTC/GMT +1 https://crazycloudcraft.de

# Configuration:
# Define your Minecraft version like 1.18.2 based on your Software
# For Velocity you set the latest PROXY version ( in the moment: 3.1.2 (just look on https://papermc.io/downloads#Velocity )
MAINVERSION=1.18.2
# What type of Server Software do you use?
# You can use: PAPER, PURPUR, MOHIST, VELOCITY, BUNGEECORD
ASOFTWARE=PAPER
# Set your folder where the subfolders of your server shall run
OPTBASE=opt
# Set your server folder where your server shall run
SERVERBASE=Paperdev
# Backups go here underneath BPATH
BPATH=Server_backups
# Do you need a Backup ? BACKUP=TRUE
BACKUP=FALSE
# What jar and screen name shall your Minecraft server have?
MCNAME=paperd
# Amount of RAM that your Mincecraft server will use (M or G) e.g.: RAM=2024M or RAM=10G
RAM=4G
# Name of your java executable (Default java) e.g.: JAVABIN=/usr/bin/java
JAVABIN=/usr/bin/java17

# --- Bedrock Edition (MCPE) ---

# Get Floodgate updater? Otherwise nobody can join without Java Edition account from Bedrock.
BESUPPORT=TRUE
# Geyser too? Because you didn't need it, if this server is connected with a proxy.
GBESUPPORT=TRUE

# Script start: Do not change after here ###############################################

# Your local absolute path
LPATH=/$OPTBASE/$SERVERBASE
mkdir -p $LPATH

#Install depencies
touch $MCNAME.jar
mkdir -p $LPATH/jar
mkdir -p $LPATH/unused
 if ! command -v joe &> /dev/null
 then
     apt-get install joe -y
     echo "joe installed"
 fi
 if ! command -v screen &> /dev/null
 then
     apt-get install screen -y
     echo "screen installed"
 fi
 if ! command -v sudo &> /dev/null
 then
     apt-get install sudo -y
     echo "sudo installed"
 fi
 if ! command -v zip &> /dev/null
 then
     apt-get install zip -y
     echo "zip installed"
 fi
 if ! command -v wget &> /dev/null
 then
     apt-get install wget -y
     echo "wget installed"
 fi
 if ! command -v xargs &> /dev/null
 then
     apt-get install findutils -y
     echo "findutils installed"
 fi
 if ! command -v diff &> /dev/null
 then
     apt-get install diffutils -y
     echo "diffutils installed"
 fi
 #Testing Dependencies
sed -i 's/false/true/g' $LPATH/eula.txt >/dev/null 2>&1
sed -i 's;restart-script: ./start.sh;restart-script: ./restart.sh;g' $LPATH/spigot.yml >/dev/null 2>&1

#Testing Dependencies 2
if screen -list | grep -q "$MCNAME"; then
    echo -e "\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m Server has already started! Use screen -r $MCNAME to open it"
    exit 1
else
echo -e "\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m Starting server..."
fi

# Change directory to server directory
cd $LPATH

# Create backup for your server
if [ $BACKUP = "TRUE" ]; then
 if [ -f "$MCNAME.jar" ]; then
    echo -e "\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m Create Backup..."
    echo "Backing up server (to /unused/$BPATH folder)" | /usr/bin/logger -t $MCNAME
    cd $LPATH/unused/$BPATH && ls -1tr | head -n -10 | xargs -d '\n' rm -f --
    cd $LPATH || exit 1
    tar -pzcf ./unused/$BPATH/backup-"$(date +%Y.%m.%d.%H.%M.%S)".tar.gz --exclude='unused/*' ./
 fi
fi

# Clean Logfiles
/usr/bin/find $LPATH/logs -type f -mtime +6 -delete > /dev/null 2>&1

#Paper: Getting Update form your selected version.
if [ $ASOFTWARE = "PAPER" ]; then
 mkdir -p $LPATH/mcsys/jar
 cd $LPATH/mcsys/jar || exit 1
 rm -f version.json
 wget -q https://api.papermc.io/v2/projects/paper/versions/$MAINVERSION/ -O version.json
 LATEST=$(cat < version.json | jq -r ".builds" | grep -v "," | grep -e "[0-9]" | tr -d " ")
 wget -q https://api.papermc.io/v2/projects/paper/versions/$MAINVERSION/builds/$LATEST/downloads/paper-$MAINVERSION-$LATEST.jar -O paper-$MAINVERSION-$LATEST.jar
 unzip -qq -t paper-$MAINVERSION-$LATEST.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded paper-$MAINVERSION-$LATEST.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  diff -q paper-$MAINVERSION-$LATEST.jar $LPATH/$MCNAME.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   cp paper-$MAINVERSION-$LATEST.jar paper-$MAINVERSION-$LATEST.jar."$(date +%Y.%m.%d.%H.%M.%S)"
   mv paper-$MAINVERSION-$LATEST.jar $LPATH/$MCNAME.jar
   /usr/bin/find $LPATH/mcsys/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   echo "paper-$MAINVERSION-$LATEST has been updated" | /usr/bin/logger -t $MCNAME
   rm version.json
  else
   echo "No paper-$MAINVERSION-$LATEST update neccessary" | /usr/bin/logger -t $MCNAME
   rm paper-$MAINVERSION-$LATEST.jar
   rm version.json
  fi
 fi
fi

#PurPur: Getting Update form your selected version.
if [ $ASOFTWARE = "PURPUR" ]; then
 mkdir -p $LPATH/mcsys/jar
 cd $LPATH/mcsys/jar || exit 1
 rm -f version.json
 wget -q https://api.purpurmc.org/v2/purpur/$MAINVERSION -O version.json
 LATEST=$(cat < version.json | jq -r ".builds" | grep -v "," | grep -v ":" | grep -e "[0-9]" | cut -d "\"" -f2)
 wget -q https://api.purpurmc.org/v2/purpur/$MAINVERSION/$LATEST/download -O purpur-$MAINVERSION-$LATEST.jar
 unzip -qq -t purpur-$MAINVERSION-$LATEST.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded purpur-$MAINVERSION-$LATEST.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  diff -q purpur-$MAINVERSION-$LATEST.jar $LPATH/$MCNAME.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   cp purpur-$MAINVERSION-$LATEST.jar purpur-$MAINVERSION-$LATEST.jar."$(date +%Y.%m.%d.%H.%M.%S)"
   mv purpur-$MAINVERSION-$LATEST.jar $LPATH/$MCNAME.jar
   /usr/bin/find $LPATH/mcsys/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   echo "purpur-$MAINVERSION-$LATEST has been updated" | /usr/bin/logger -t $MCNAME
   rm version.json
  else
   echo "No purpur-$MAINVERSION-$LATEST update neccessary" | /usr/bin/logger -t $MCNAME
   rm purpur-$MAINVERSION-$LATEST.jar
   rm version.json
  fi
 fi
fi
#Mohist: Getting Update form your selected version.
if [ $ASOFTWARE = "MOHIST" ]; then
 mkdir -p $LPATH/mcsys/jar
 cd $LPATH/mcsys/jar || exit 1
 DATE=$(date +%Y.%m.%d.%H.%M.%S)
 wget -q https://mohistmc.com/api/$MAINVERSION/latest/download -O mohist-$MAINVERSION-$DATE.jar
 unzip -qq -t  mohist-$MAINVERSION-$DATE.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded mohist-$MAINVERSION-$DATE.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  diff -q mohist-$MAINVERSION-$DATE.jar $LPATH/$MCNAME.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   cp mohist-$MAINVERSION-$DATE.jar  mohist-$MAINVERSION-$DATE.jar.backup
   mv mohist-$MAINVERSION-$DATE.jar $LPATH/$MCNAME.jar
   /usr/bin/find $LPATH/mcsys/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   echo "mohist-$MAINVERSION-$DATE.jar has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No mohist-$MAINVERSION-$DATE.jar update neccessary" | /usr/bin/logger -t $MCNAME
   rm mohist-$MAINVERSION-$DATE.jar
  fi
 fi
fi

#Spigot: Getting Update form your selected version.
#Spigot: Getting Update form your selected version.
if [ $ASOFTWARE = "SPIGOT" ] || [ $ASOFTWARE = "BUKKIT" ]; then
 mkdir -p $LPATH/mcsys/build
 mkdir -p $LPATH/mcsys/spitool
 cd $LPATH/mcsys/build || exit 1
 wget -q https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -O BuildTools.jar
 unzip -qq -t BuildTools.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded BuildTools.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  if [ -f $LPATH/mcsys/spitool/BuildTools.jar ]; then
   echo "BuildTools exists" | /usr/bin/logger -t $MCNAME
  else
   touch $LPATH/mcsys/spitool/BuildTools.jar
  fi
  diff BuildTools.jar $LPATH/mcsys/spitool/BuildTools.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   cd $LPATH/mcsys/build || exit 1
   cp BuildTools.jar $LPATH/mcsys/spitool/BuildTools.jar
   if [ $ASOFTWARE = "SPIGOT" ]; then
    java -jar BuildTools.jar --rev $MAINVERSION
    cp ./BuildTools/spigot-$MAINVERSION.jar ./spigot-$MAINVERSION.jar"$(date +%Y.%m.%d.%H.%M.%S)"
    mv ./BuildTools/spigot-$MAINVERSION.jar $LPATH/$MCNAME.jar
   fi
   if [ $ASOFTWARE = "BUKKIT" ]; then
    java -jar BuildTools.jar --rev $MAINVERSION --compile craftbukkit
    cp ./BuildTools/craftbukkit-$MAINVERSION.jar ./craftbukkit-$MAINVERSION.jar"$(date +%Y.%m.%d.%H.%M.%S)"
    mv ./BuildTools/craftbukkit-$MAINVERSION.jar $LPATH/$MCNAME.jar
   fi
   rm -r BuildTools
   cd $LPATH/mcsys/spitool/ || exit 1
   mv BuildTools.jar BuildTools.jar"$(date +%Y.%m.%d.%H.%M.%S)"
   /usr/bin/find $LPATH/mcsys/build/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   /usr/bin/find $LPATH/mcsys/spitool/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME»
   echo "spigot-$MAINVERSION.jar has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No BuildTools.jar update neccessary" | /usr/bin/logger -t $MCNAME
   rm BuildTools.jar
  fi
 fi
fi

#Velocity: Getting Update form your selected version.
