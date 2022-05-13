#!/bin/bash
# READY FOR TESTING CrazyCloudCraft Argantiu
# Software type
ASOFTWARE=SPIGOT
# The Minecraft Version
MAINVERSION=1.18.2
MCNAME=mctest15
LPATH=/opt/test
#Spigot: Getting Update form your selected version.
if [ $ASOFTWARE = "SPIGOT" ]; then
 mkdir -p $LPATH/mcsys/build
 mkdir -p $LPATH/mcsys/spitool
 cd $LPATH/mcsys/build || exit
 wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
 unzip -qq -t BuildTools.jar
 if ! unzip -qq -t BuildTools.jar; then
  echo "Downloaded BuildTools.jar is corrupt. No update." #| /usr/bin/logger -t $MCNAME
 else
  diff BuildTools.jar $LPATH/mcsys/spitool/BuildTools.jar #>/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   /usr/bin/find $LPATH/mcsys/build/* -type f -mtime +10 -delete 2>&1 #| /usr/bin/logger -t $MCNAME
   /usr/bin/find $LPATH/mcsys/spitool/* -type f -mtime +10 -delete 2>&1 #| /usr/bin/logger -t $MCNAME
   cd $LPATH/mcsys/build || exit
   cp BuildTools.jar $LPATH/mcsys/spitool/BuildTools.jar
   java -jar BuildTools.jar --rev $MAINVERSION
   cp ./BuildTools/spigot-$MAINVERSION.jar ./spigot-$MAINVERSION.jar"$(date +%Y.%m.%d.%H.%M.%S)"
   mv ./BuildTools/spigot-$MAINVERSION.jar $LPATH/$MCNAME.jar
   rm -r BuildTools
   cd ../spitool/ || exit
   mv BuildTools.jar BuildTools.jar"$(date +%Y.%m.%d.%H.%M.%S)"
   echo "spigot-$MAINVERSION.jar has been updated" #| /usr/bin/logger -t $MCNAME
  else
   echo "No BuildTools.jar update neccessary" #| /usr/bin/logger -t $MCNAME
   rm BuildTools.jar
  fi
 fi
fi
