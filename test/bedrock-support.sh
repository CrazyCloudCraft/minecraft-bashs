#!/bin/bash
ASOFTWARE=SPIGOT
BESUPPORT=TRUE
LPATH=Coding
mkdir -p $LPATH/plugins
mkdir -p $LPATH/mcsys/

if [ $ASOFTWARE = "PAPER" ] || [ $ASOFTWARE = "SPIGOT" ] && [ $BESUPPORT = "TRUE" ]; then
 cd $LPATH/plugins || exit
 touch floodgate-spigot.jar
 cd $LPATH/mcsys/floodgate || exit
 wget -q https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/spigot/target/floodgate-spigot.jar
 unzip -qq -t floodgate-spigot.jar
 if ! unzip -qq -t floodgate-spigot.jar; then
  echo "Downloaded floodgate is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  diff -q floodgate-spigot.jar ../../plugins/floodgate-spigot.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
  /usr/bin/find $LPATH/mcsys/floodgate/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
  cp floodgate-spigot.jar floodgate-spigot.jar."$(date +%Y.%m.%d.%H.%M.%S)"
  mv floodgate-spigot.jar ../../plugins/floodgate-spigot.jar
   echo "floodgate has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No floodgate update neccessary" | /usr/bin/logger -t $MCNAME
   rm floodgate-spigot.jar
  fi
 fi
fi
