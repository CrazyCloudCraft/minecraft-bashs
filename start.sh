#!/bin/bash
# Minecraft Server start script - Check if server is already started
# Version 2.0 made by CrazyCloudCraft 08.12.2021 https://crazycloudcraft.de
# Version 2.1 made by CrazyCloudCraft 11.12.2021 https://crazycloudcraft.de
# Version 2.2 made by CrazyCloudCraft 14.01.2022 https://crazycloudcraft.de
# Version 2.3 made by CrazyCloudCraft 14.01.2022 https://crazycloudcraft.de 
# Version 2.3-dev.1 made by CrazyCloudCraft 02.03.2022 https://crazycloudcraft.de 

# Configuration:
# Define your Minecraft version like 1.17, 1.17.1, 1.18, 1.18.1 based on PaperMC and PurPurMC
# For Velocity you set the latest PROXY version ( in the moment: 3.1.1 )
MAINVERSION=1.18.1
# What type of Server Software do you use? 
# You can use: PAPER or PURPUR 
# And for Proxy: VELOCITY
ASOFTWARE=PAPER
# Set your folder where the subfolders of your server shall run
OPTBASE=opt
# Set your server folder where your server shall run
SERVERBASE=Paper
# Backups go here underneath BPATH
BPATH=Paper_backups
# Do you need a Backup ? BACKUP=TRUE
BACKUP=FALSE
# What jar and screen name shall your Minecraft server have?
MCNAME=paper
# Amount of RAM that your Mincecraft server will use (M or G) e.g.: RAM=2024M or RAM=10G
RAM=5G
# Name of your java executable (Default java) e.g.: JAVABIN=/usr/bin/java
JAVABIN=java17
#Minecraft Bedrock (PE)
# Do you need Floodgate?
UPDATEFLOOD=TRUE
# Do you need Geyser? (Only on PurPur and Paper standalone)
UPDATEGEYSER=FALSE
# Do you need Geyer on Velocity? (Proxy) 
# (Floodgate must bee enabled by the standalone servers)
PRUPDATEGEYSER=FALSE







# Script start: Do not change after here ###############################################


# Your local absolute path
LPATH=/$OPTBASE/$SERVERBASE
mkdir -p $LPATH

#Install depencies

#Testing Dependencies
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
    tar -pzcf ../$BPATH/$(date +%Y.%m.%d.%H.%M.%S).tar.gz --exclude='FaWeSnapshots/*' --exclude='worlds_archive/*' ./
 fi
fi

# Clean Logfiles
/usr/bin/find $LPATH/logs -type f -mtime +6 -delete > /dev/null 2>&1

#Paper: Getting Update form your selected version.
if [ $ASOFTWARE = "PAPER" ]; then
 cd $LPATH/jar
 wget -q https://papermc.io/api/v2/projects/paper/versions/$MAINVERSION/ -O version.json
 LATEST=`cat version.json | jq -r ".builds" | grep -v "," | grep -e "[0-9]" | tr -d " "`
 rm version.json
 wget -q https://papermc.io/api/v2/projects/paper/versions/$MAINVERSION/builds/$LATEST/downloads/$MCNAME-$MAINVERSION-$LATEST.jar
 unzip -qq -t paper-$MAINVERSION-$LATEST.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded paper-$MAINVERSION-$LATEST.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  diff -q paper-$MAINVERSION-$LATEST.jar ../$MCNAME.jar
  if [ "$?" -eq 1 ]; then
   /usr/bin/find $LPATH/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   cp paper-$MAINVERSION-$LATEST.jar paper-$MAINVERSION-$LATEST.jar.$(date +%Y.%m.%d.%H.%M.%S)
   mv paper-$MAINVERSION-$LATEST.jar $LPATH/$MCNAME.jar
   echo "paper-$MAINVERSION-$LATEST has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No paper-$MAINVERSION-$LATEST update neccessary" | /usr/bin/logger -t $MCNAME
   rm paper-$MAINVERSION-$LATEST.jar
  fi
 fi
fi

#PurPur: Getting Update form your selected version.
if [ $ASOFTWARE = "PURPUR" ]; then
 cd $LPATH/jar
 wget -q https://api.purpurmc.org/v2/purpur/$MAINVERSION -O version.json
 LATEST=`cat version.json | jq -r ".builds" | grep -v "," | grep -e "[0-9]" | tr -d " "`
 rm version.json
 wget -q https://api.purpurmc.org/v2/purpur/$MAINVERSION/latest/download
 unzip -qq -t purpur-$MAINVERSION-$LATEST.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded purpur-$MAINVERSION-$LATEST.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  diff -q purpur-$MAINVERSION-$LATEST.jar ../$MCNAME.jar
  if [ "$?" -eq 1 ]; then
   /usr/bin/find $LPATH/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   cp purpur-$MAINVERSION-$LATEST.jar purpur-$MAINVERSION-$LATEST.jar.$(date +%Y.%m.%d.%H.%M.%S)
   mv purpur-$MAINVERSION-$LATEST.jar $LPATH/$MCNAME.jar
   echo "purpur-$MAINVERSION-$LATEST has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No purpur-$MAINVERSION-$LATEST update neccessary" | /usr/bin/logger -t $MCNAME
   rm purpur-$MAINVERSION-$LATEST.jar
  fi
 fi
fi

#Velocity: Getting Update form your selected version.
if [ $ASOFTWARE = "VELOCITY" ]; then
 cd $LPATH/jar
 wget -q https://papermc.io/api/v2/projects/velocity/versions/$MAINVERSION/ -O version.json
 LATEST=`cat version.json | jq -r ".builds" | grep -v "," | grep -e "[0-9]" | tr -d " "`
 rm version.json
 wget -q https://papermc.io/api/v2/projects/velocity/versions/$MAINVERSION/builds/$LATEST/downloads/$MCNAME-$MAINVERSION-$LATEST.jar
 unzip -qq -t velocity-$MAINVERSION-$LATEST.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded velocity-$MAINVERSION-$LATEST.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  diff -q velocity-$MAINVERSION-$LATEST.jar ../$MCNAME.jar
  if [ "$?" -eq 1 ]; then
   /usr/bin/find $LPATH/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   cp velocity-$MAINVERSION-$LATEST.jar paper-$MAINVERSION-$LATEST.jar.$(date +%Y.%m.%d.%H.%M.%S)
   mv velocity-$MAINVERSION-$LATEST.jar $LPATH/$MCNAME.jar
   echo "velocity-$MAINVERSION-$LATEST has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No velocity-$MAINVERSION-$LATEST update neccessary" | /usr/bin/logger -t $MCNAME
   rm paper-$MAINVERSION-$LATEST.jar
  fi
 fi
fi

# Start Bedrock edition part
#Floodgate: Updateing floodgate for Minecraft PE https://geysermc.org for more information
if [ UPDATEFLOOD = "TRUE" ]; then
 cd $LPATH/floodgate 
 wget -q https://ci.opencollab.dev//job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/spigot/target/floodgate-spigot.jar -O floodgate-spigot.jar
 unzip -qq -t floodgate-spigot.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded floodgate-spigot.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  diff -q floodgate-spigot.jar ../plugins/floodgate-spigot.jar
  if [ "$?" -eq 1 ]; then
   /usr/bin/find $LPATH/floodgate/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   cp floodgate-spigot.jar floodgate-spigot.jar.$(date +%Y.%m.%d.%H.%M.%S)
   mv floodgate-spigot.jar $LPATH/plugins/floodgate-spigot.jar
   echo "floodgate-bukkit has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No floodgate-bukkit update neccessary" | /usr/bin/logger -t $MCNAME
   rm floodgate-spigot.jar
  fi
 fi
fi

#Geyser: Updating Geyser for Minecraft Connections
if [ UPDATEGEYSER = "TRUE" ]; then
 cd $LPATH/geyser 
 wget -q https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/spigot/target/Geyser-Spigot.jar -O Geyser-Spigot.jar
 unzip -qq -t Geyser-Spigot.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded Geyser-Spigot.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  diff -q Geyser-Spigot.jar ../plugins/Geyser-Spigot.jar
  if [ "$?" -eq 1 ]; then
   /usr/bin/find $LPATH/geyser/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   cp Geyser-Spigot.jar Geyser-Spigot.jar.$(date +%Y.%m.%d.%H.%M.%S)
   mv Geyser-Spigot.jar $LPATH/plugins/Geyser-Spigot.jar
   echo "Geyser-Spigot has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No Geyser-Spigot update neccessary" | /usr/bin/logger -t $MCNAME
   rm Geyser-Spigot.jar
  fi
 fi
fi

#GeyserPROXY: Plugin-Update holen und ggfs installieren
if [ PRUPDATEGEYSER = "TRUE" ]; then
 cd /opt/Bungee/geyser
 wget -q https://ci.opencollab.dev//job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/bungeecord/target/Geyser-BungeeCord.jar -O Geyser-BungeeCord.jar
 unzip -qq -t Geyser-BungeeCord.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded Geyser-BungeeCord.jar is corrupt. No update." | /usr/bin/logger -t bungee
 else
  diff -q Geyser-BungeeCord.jar ../plugins/Geyser-BungeeCord.jar
  if [ "$?" -eq 1 ]; then
   /usr/bin/find /opt/Bungee/geyser/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t bungee
   cp Geyser-BungeeCord.jar Geyser-BungeeCord.jar.$(date +%Y.%m.%d.%H.%M.%S)
   mv Geyser-BungeeCord.jar /opt/Bungee/plugins/Geyser-BungeeCord.jar
   echo "Geyser-BungeeCord has been updated" | /usr/bin/logger -t bungee
  else
   echo "No Geyser-BungeeCord update neccessary" | /usr/bin/logger -t bungee
   rm Geyser-BungeeCord.jar
  fi
 fi
fi

# Stop Bedrock edition part

#Starting paper server
cd $LPATH

if [ $ASOFTWARE = "PAPER" ]; then
screen -d -m -L -S $MCNAME  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar $MCNAME.jar nogui"
fi

if [ $ASOFTWARE = "PURPUR" ]; then
screen -d -m -L -S $MCNAME  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar $MCNAME.jar nogui"
fi

if [ $ASOFTWARE = "VELOCITY" ]; then
screen -d -m -L -S $MCNAME  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -XX:MaxInlineLevel=15 -jar velocity.jar"
fi
