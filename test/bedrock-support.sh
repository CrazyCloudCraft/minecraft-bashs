#!/bin/bash
ASOFTWARE=SPIGOT
BESUPPORT=TRUE
GBESUPPORT=TRUE
LPATH=Coding
mkdir -p $LPATH/plugins
mkdir -p $LPATH/mcsys

# Floodgate for Spigot
if [ $ASOFTWARE = "PAPER" ] || [ $ASOFTWARE = "SPIGOT" ] || [ $ASOFTWARE = "PURPUR" ] && [ $BESUPPORT = "TRUE" ]; then
 cd $LPATH/plugins || exit
# touch floodgate-spigot.jar
 mkdir -p $LPATH/mcsys/floodgate
 cd $LPATH/mcsys/floodgate || exit
 wget -q https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/spigot/target/floodgate-spigot.jar
 unzip -qq -t floodgate-spigot.jar
 if ! unzip -qq -t floodgate-spigot.jar; then
  echo "Downloaded floodgate is corrupt. No update." | /usr/bin/logger -t $MCNAME
# else
#  diff -q floodgate-spigot.jar ../../plugins/floodgate-spigot.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
  /usr/bin/find $LPATH/mcsys/floodgate/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
  cp floodgate-spigot.jar floodgate-spigot.jar."$(date +%Y.%m.%d.%H.%M.%S)"
  mv floodgate-spigot.jar ../../plugins/floodgate-spigot.jar
   echo "floodgate has been updated" | /usr/bin/logger -t $MCNAME
#  else
#   echo "No floodgate update neccessary" | /usr/bin/logger -t $MCNAME
#   rm floodgate-spigot.jar
  fi
 fi
fi

# Floodgate for Proxy
if [ $ASOFTWARE = "BUNGEECORD" ] || [ $ASOFTWARE = "VELOCITY" ] || [ && [ $BESUPPORT = "TRUE" ]; then
 cd $LPATH/plugins || exit
 mkdir -p $LPATH/mcsys/floodgate
 cd $LPATH/mcsys/floodgate || exit
 if [ $ASOFTWARE = "BUNGEECORD" ] || [ $ASOFTWARE = "WATERFALL" ]; then
 wget -q https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/bungee/target/floodgate-bungee.jar
 unzip -qq -t floodgate-bungee.jar
 if ! unzip -qq -t floodgate-bungee.jar; then
  echo "Downloaded floodgate is corrupt. No update." | /usr/bin/logger -t $MCNAME
# else
#  diff -q floodgate-spigot.jar ../../plugins/floodgate-spigot.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
  /usr/bin/find $LPATH/mcsys/floodgate/* -type f -mtime +6 -delete 2>&1 | /usr/bin/logger -t $MCNAME
  cp floodgate-bungee.jar floodgate-bungee.jar."$(date +%Y.%m.%d.%H.%M.%S)"
  mv floodgate-bungee.jar ../../plugins/floodgate-bungee.jar
   echo "floodgate has been updated" | /usr/bin/logger -t $MCNAME
#  else
#   echo "No floodgate update neccessary" | /usr/bin/logger -t $MCNAME
#   rm floodgate-bungee.jar
 if [ $ASOFTWARE = "VELOCITY" ]; then
 wget -q https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/velocity/target/floodgate-velocity.jar
 unzip -qq -t floodgate-velocity.jar
 if ! unzip -qq -t floodgate-velocity.jar; then
  echo "Downloaded floodgate is corrupt. No update." | /usr/bin/logger -t $MCNAME
# else
#  diff -q floodgate-spigot.jar ../../plugins/floodgate-spigot.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
  /usr/bin/find $LPATH/mcsys/floodgate/* -type f -mtime +6 -delete 2>&1 | /usr/bin/logger -t $MCNAME
  cp floodgate-velocity.jar floodgate-velocity.jar."$(date +%Y.%m.%d.%H.%M.%S)"
  mv floodgate-velocity.jar ../../plugins/floodgate-velocity.jar
   echo "floodgate has been updated" | /usr/bin/logger -t $MCNAME
#  else
#   echo "No floodgate update neccessary" | /usr/bin/logger -t $MCNAME
#   rm floodgate-bungee.jar
  fi
 fi
fi

# Geyser Updater for nomal servers
if [ $ASOFTWARE = "PAPER" ] || [ $ASOFTWARE = "SPIGOT" ] || [ $ASOFTWARE = "PURPUR" ] && [ $GBESUPPORT = "TRUE" ]; then
 cd $LPATH/plugins || exit
# touch Geyser-Spigot.jar
 mkdir -p $LPATH/mcsys/geyser
 cd $LPATH/mcsys/geyser || exit
 wget -q https://ci.opencollab.dev//job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/spigot/target/Geyser-Spigot.jar
 unzip -qq -t Geyser-Spigot.jar
 if ! unzip -qq -t Geyser-Spigot.jar; then
  echo "Downloaded floodgate is corrupt. No update." | /usr/bin/logger -t $MCNAME
# else
#  diff -q floodgate-spigot.jar ../../plugins/floodgate-spigot.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
  /usr/bin/find $LPATH/mcsys/geyser/* -type f -mtime +6 -delete 2>&1 | /usr/bin/logger -t $MCNAME
  cp Geyser-Spigot.jar Geyser-Spigot.jar."$(date +%Y.%m.%d.%H.%M.%S)"
  mv Geyser-Spigot.jar ../../plugins/Geyser-Spigot.jar
   echo "floodgate has been updated" | /usr/bin/logger -t $MCNAME
#  else
#   echo "No floodgate update neccessary" | /usr/bin/logger -t $MCNAME
#   rm floodgate-spigot.jar
  fi
 fi
fi

