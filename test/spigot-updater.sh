#!/bin/bash

#Spigot: Getting Update form your selected version.
if [ $ASOFTWARE = "SPIGOT" ]; then
 mkdir -p $LPATH/mcsys/build
 cd $LPATH/mcsys/build || exit
#  https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
 wget -q https://papermc.io/api/v2/projects/paper/versions/$MAINVERSION/ -O version.json
 LATEST=$(cat < version.json | jq -r ".builds" | grep -v "," | grep -e "[0-9]" | tr -d " ")
 wget -q https://papermc.io/api/v2/projects/paper/versions/$MAINVERSION/builds/$LATEST/downloads/paper-$MAINVERSION-$LATEST.jar
 unzip -qq -t paper-$MAINVERSION-$LATEST.jar
 #if [ "$?" -ne 0 ]; then 
 if ! unzip -qq -t paper-$MAINVERSION-$LATEST.jar; then
  echo "Downloaded paper-$MAINVERSION-$LATEST.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  diff -q paper-$MAINVERSION-$LATEST.jar ../$MCNAME.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   /usr/bin/find $LPATH/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   cp paper-$MAINVERSION-$LATEST.jar paper-$MAINVERSION-$LATEST.jar."$(date +%Y.%m.%d.%H.%M.%S)"
   mv paper-$MAINVERSION-$LATEST.jar $LPATH/$MCNAME.jar
   echo "paper-$MAINVERSION-$LATEST has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No paper-$MAINVERSION-$LATEST update neccessary" | /usr/bin/logger -t $MCNAME
   rm paper-$MAINVERSION-$LATEST.jar
   rm version.json
  fi
 fi
fi
