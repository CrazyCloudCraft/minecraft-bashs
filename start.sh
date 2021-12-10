#!/bin/bash
# Minecraft Server start script - Check if server is already started
# Made by CrazyCloudCraft 08.12.2021 https://crazycloudcraft.de
# Version 2.0 Configuration:

# Set your Minecraft version like 1.17, 1.17.1, 1.18
MAINVERSION=1.17.1
# Set your server path. Where is your paper.jar?
LPATH=/opt/Paper
# Backups go here underneath /opt
BPATH=Paper_backups
# What jar and screen name does your Minecraft Server have?
MCNAME=paper

# Don't forget to set your ... -Xms2048M -Xmx2048M ... at the end of this script!


# Script start. Do not configure this!

if screen -list | grep -q "$MCNAME "; then
    echo "Server has already started! Use screen -r $MCNAME to open it"
    exit 1
fi

# Change directory to server directory
cd $LPATH

# Create backup for your server
if [ -d "jar" ]; then
    echo "Backing up server (to /opt/$BPATH folder)" | /usr/bin/logger -t $MCNAME
    cd /opt/$BPATH && ls -1tr | head -n -10 | xargs -d '\n' rm -f --
    cd $LPATH
    tar -pzcf ../$BPATH/$(date +%Y.%m.%d.%H.%M.%S).tar.gz --exclude='FaWeSnapshots/*' --exclude='worlds_archive/*' ./
fi


# Clean Logfiles
/usr/bin/find $LPATH/logs -type f -mtime +6 -delete > /dev/null 2>&1

#Paper: Getting Update form your selected version.
cd $LPATH/jar
wget -q https://papermc.io/api/v2/projects/paper/versions/$MAINVERSION/ -O version.json
LATEST=`cat version.json | jq -r ".builds" | grep -v "," | grep -e "[0-9]" | tr -d " "`
rm version.json
wget -q https://papermc.io/api/v2/projects/paper/versions/$MAINVERSION/builds/$LATEST/downloads/$MCNAME-$MAINVERSION-$LATEST.jar
unzip -qq -t $MCNAME-$MAINVERSION-$LATEST.jar
if [ "$?" -ne 0 ]; then
 echo "Downloaded $MCNAME-$MAINVERSION-$LATEST.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
else
 diff -q $MCNAME-$MAINVERSION-$LATEST.jar ../$MCNAME.jar
if [ "$?" -eq 1 ]; then
  /usr/bin/find $LPATH/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
  cp $MCNAME-$MAINVERSION-$LATEST.jar $MCNAME-$MAINVERSION-$LATEST.jar.$(date +%Y.%m.%d.%H.%M.%S)
  mv $MCNAME-$MAINVERSION-$LATEST.jar $LPATH/$MCNAME.jar
  echo "$MCNAME-$MAINVERSION-$LATEST has been updated" | /usr/bin/logger -t $MCNAME
 else
  echo "No $MCNAME-$MAINVERSION-$LATEST update neccessary" | /usr/bin/logger -t $MCNAME
  rm $MCNAME-$MAINVERSION-$LATEST.jar
 fi
fi


# Bedrock edition part: Just remove it if you don't need this


#Floodgate: Updateing floodgate for Minecraft PE https://geysermc.org for more information
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

Geyser: Updating Geyser for Minecraft Connections
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

# Bedrock edition part: end



#Starting paper server
cd $LPATH
# What you can write here!
#screen -d -m -L -S $MCNAME /bin/bash -c "/usr/bin/java -Xms2G -Xmx2G -jar $MCNAME.jar"

# Online with:
screen -d -m -L -S $MCNAME /bin/bash -c "/usr/bin/java -Xms2048M -Xmx2048M -jar $MCNAME.jar"

# More information ...
#https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft/ mit 4GB
#screen -d -m -L -S $MCNAME /bin/bash -c "java -Xms4G -Xmx4G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar $MCNAME.jar nogui"
