#!/bin/bash
# READY FOR TESTING CrazyCloudCraft Argantiu
# Software type
ASOFTWARE=BUKKIT
# The Minecraft Version
MAINVERSION=1.18.2

#Spigot: Getting Update form your selected version.
if [ $ASOFTWARE = "BUKKIT" ]; then
 mkdir -p $LPATH/mcsys/build
 mkdir -p $LPATH/mcsys/spitool
 cd $LPATH/mcsys/build || exit
 wget -q https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
 unzip -qq -t BuildTools.jar
 if ! unzip -qq -t BuildTools.jar; then
  echo "Downloaded BuildTools.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  diff -q BuildTools.jar ../spitool/BuildTools.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   /usr/bin/find $LPATH/mcsys/build/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   /usr/bin/find $LPATH/mcsys/spitool/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   cd ../spitool/ || exit
   mv BuildTools.jar BuildTools.jar"$(date +%Y.%m.%d.%H.%M.%S)"
   cd ../build || exit
   cp BuildTools.jar ../spitool/BuildTools.jar
   java -jar BuildTools.jar --rev $MAINVERSION --compile craftbukkit
   cp ./BuildTools/spigot-$MAINVERSION.jar ./spigot-$MAINVERSION.jar"$(date +%Y.%m.%d.%H.%M.%S)" $LPATH/$MCNAME.jar
   mv spigot-$MAINVERSION.jar $LPATH/$MCNAME.jar
   rm -r BuildTools
   echo "spigot-$MAINVERSION.jar has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No BuildTools.jar update neccessary" | /usr/bin/logger -t $MCNAME
   rm BuildTools.jar
  fi
 fi
fi
