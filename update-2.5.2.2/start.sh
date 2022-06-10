#!/bin/bash
# Minecraft Server start script -|- Check if server is already started
# Version 2.5.2.2 made by CrazyCloudCraft 2022-06-10 UTC/GMT +1 https://crazycloudcraft.de

# Use STRG + k + x to save this settings (with joe's editor)
# Use STRG + c to close it without saveing
# Configuration:

# Define your Minecraft version. For exaple 1.18.2, 1.18.1, 1.18, ...
# Some software types don't need the Minecraft version e. g. velocity or bungeecord.
# But it's better when you set here a version.
MAINVERSION=1.18.2

# Velocity Version. Please only change, if there is a new version.
PRMCVERSION=3.1.2

# What type of server software do you use? 
# You can use: < PAPER | PURPUR | MOHIST | VELOCITY | BUNGEECORD | SPIGOT | BUKKIT >
ASOFTWARE=PAPER

# Do you have a Subfolder for your server(s)? We recommend to set and use one.
# E.g. home/server/(serverbase) or opt/(serverbase)
OPTBASE=opt

# Set your server folder, where your server shall run (serverbase).
SERVERBASE=Paperdev

# Backups go here underneath BPATH
BPATH=Server_backups

# Do you need a Backup ? BACKUP=TRUE
BACKUP=FALSE

# Wich system-name should have the console and main.jar?
# Don't use something like "system" or "main" for example, 
# because the system sometimes already use this names.
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
mkdir -p $LPATH/plugins
mkdir -p $LPATH/mcsys
if [ -f server_installer-*.sh ]; then
   rm server_installer-*.sh
fi
if [ -f start.sh~ ]; then
   rm start.sh~
fi
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
# Replace settings
sed -i "0,/OPTBASE=.*/s//OPTBASE=$OPTBASE/" $LPATH/restart.sh >/dev/null 2>&1
sed -i "0,/SERVERBASE=.*/s//SERVERBASE=$SERVERBASE/" $LPATH/restart.sh >/dev/null 2>&1
sed -i "0,/MCNAME=.*/s//MCNAME=$MCNAME/" $LPATH/stop.sh >/dev/null 2>&1
sed -i "0,/DISPLAYNAME=.*/s//DISPLAYNAME=$SERVERBASE/" $LPATH/stop.sh >/dev/null 2>&1

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
if [ $ASOFTWARE = "VELOCITY" ]; then
 mkdir -p $LPATH/mcsys/jar
 cd $LPATH/mcsys/jar || exit 1
 rm -f version.json
 wget -q https://api.papermc.io/v2/projects/velocity/versions/$PRMCVERSION-SNAPSHOT -O version.json
 LATEST=$(cat < version.json | jq -r ".builds" | grep -v "," | grep -e "[0-9]" | tr -d " ")
 wget -q https://api.papermc.io/v2/projects/velocity/versions/$PRMCVERSION-SNAPSHOT/builds/$LATEST/downloads/velocity-$PRMCVERSION-SNAPSHOT-$LATEST.jar -O velocity-$PRMCVERSION-SNAPSHOT-$LAT
 unzip -qq -t velocity-$PRMCVERSION-SNAPSHOT-$LATEST.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded velocity-$PRMCVERSION-SNAPSHOT-$LATEST.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  diff -q velocity-$PRMCVERSION-SNAPSHOT-$LATEST.jar $LPATH/$MCNAME.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   cp velocity-$PRMCVERSION-SNAPSHOT-$LATEST.jar velocity-$PRMCVERSION-SNAPSHOT-$LATEST.jar."$(date +%Y.%m.%d.%H.%M.%S)"
   mv velocity-$PRMCVERSION-SNAPSHOT-$LATEST.jar $LPATH/$MCNAME.jar
   /usr/bin/find $LPATH/mcsys/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   echo "velocity-$PRMCVERSION-SNAPSHOT-$LATEST has been updated" | /usr/bin/logger -t $MCNAME
   rm version.json
  else
   echo "No velocity-$PRMCVERSION-SNAPSHOT-$LATEST update neccessary" | /usr/bin/logger -t $MCNAME
   rm velocity-$PRMCVERSION-SNAPSHOT-$LATEST.jar
   rm version.json
  fi
 fi
fi

#Bungeecord: Getting Update form your selected version.
if [ $ASOFTWARE = "BUNGEECORD" ]; then
 cd $LPATH/mcsys/jar || exit 1
 rm -f version.json
 wget -q https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar
 unzip -qq -t BungeeCord.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded BungeeCord.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  diff -q BungeeCord.jar $LPATH/$MCNAME.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   cp BungeeCord.jar BungeeCord.jar."$(date +%Y.%m.%d.%H.%M.%S)"
   mv BungeeCord.jar $LPATH/$MCNAME.jar
   /usr/bin/find $LPATH/mcsys/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   echo "BungeeCord.jar has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No BungeeCord.jar update neccessary" | /usr/bin/logger -t $MCNAME
   rm BungeeCord.jar
   rm -f version.json
  fi
 fi
fi
# Bedrock Updater

# Floodgate for Spigot
if [[ $ASOFTWARE == "PAPER" ]] || [[ $ASOFTWARE == "SPIGOT" ]] || [[ $ASOFTWARE == "BUKKIT" ]] || [[ $ASOFTWARE == "PURPUR" ]] && [[ $BESUPPORT == "TRUE" ]]; then
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

# Geyser Updater for nomal servers
if [[ $ASOFTWARE == "PAPER" ]] || [[ $ASOFTWARE == "SPIGOT" ]] || [[ $ASOFTWARE == "BUKKIT" ]] || [[ $ASOFTWARE == "PURPUR" ]] && [[ $GBESUPPORT == "TRUE" ]]; then
 cd $LPATH/plugins || exit 1
 mkdir -p $LPATH/mcsys/geyser
 cd $LPATH/mcsys/geyser || exit 1
 wget -q https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/spigot/target/Geyser-Spigot.jar -O Geyser-Spigot.jar
 unzip -qq -t Geyser-Spigot.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded Geyser Default is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  if [ -f $LPATH/plugins/Geyser-Spigot.jar ]; then
   echo "Geyser default plugin exists" | /usr/bin/logger -t $MCNAME
  else
   touch $LPATH/plugins/Geyser-Spigot.jar
  fi
  diff -q Geyser-Spigot.jar $LPATH/plugins/Geyser-Spigot.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   cp Geyser-Spigot.jar Geyser-Spigot.jar."$(date +%Y.%m.%d.%H.%M.%S)"
   mv Geyser-Spigot.jar $LPATH/plugins/Geyser-Spigot.jar
   /usr/bin/find $LPATH/mcsys/geyser/* -type f -mtime +6 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   echo "Geyser Default has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No Geyser default update neccessary" | /usr/bin/logger -t $MCNAME
   rm Geyser-Spigot.jar
  fi
 fi
fi

# Floodgate for Proxy
if [[ $ASOFTWARE == "BUNGEECORD" ]] || [[ $ASOFTWARE == "VELOCITY" ]] || [[ $ASOFTWARE == "WATERFALL" ]] && [[ $BESUPPORT == "TRUE" ]]; then
 cd $LPATH/plugins || exit 1
 mkdir -p $LPATH/mcsys/floodgate
 cd $LPATH/mcsys/floodgate || exit 1
 if [ $ASOFTWARE = "BUNGEECORD" ] || [ $ASOFTWARE = "WATERFALL" ]; then
 wget -q https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/bungee/target/floodgate-bungee.jar -O floodgate-bungee.jar
 unzip -qq -t floodgate-bungee.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded floodgate for Bungeecord and Waterfall is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  if [ -f $LPATH/plugins/floodgate-bungee.jar ]; then
   echo "Geyser bungee plugin exists" | /usr/bin/logger -t $MCNAME
  else
   touch $LPATH/plugins/floodgate-bungee.jar
  fi
  diff -q floodgate-bungee.jar $LPATH/plugins/floodgate-bungee.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   cp floodgate-bungee.jar floodgate-bungee.jar."$(date +%Y.%m.%d.%H.%M.%S)"
   mv floodgate-bungee.jar $LPATH/plugins/floodgate-bungee.jar
   /usr/bin/find $LPATH/mcsys/floodgate/* -type f -mtime +6 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   echo "floodgate for Bungeecord and Waterfall has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No floodgate bungee update neccessary" | /usr/bin/logger -t $MCNAME
   rm floodgate-bungee.jar
  fi
 fi
 fi
# Velocity part
 if [[ $ASOFTWARE == "VELOCITY" ]]; then
 wget -q https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/velocity/target/floodgate-velocity.jar -O floodgate-velocity.jar
 unzip -qq -t floodgate-velocity.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded floodgate for velocity is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  if [ -f $LPATH/plugins/floodgate-velocity.jar ]; then
   echo "floodgate-velocity.jar plugin exists" | /usr/bin/logger -t $MCNAME
  else
   touch $LPATH/plugins/floodgate-velocity.jar
  fi
  diff -q floodgate-velocity.jar $LPATH/plugins/floodgate-velocity.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   cp floodgate-velocity.jar floodgate-velocity.jar."$(date +%Y.%m.%d.%H.%M.%S)"
   mv floodgate-velocity.jar $LPATH/plugins/floodgate-velocity.jar
   /usr/bin/find $LPATH/mcsys/floodgate/* -type f -mtime +6 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   echo "floodgate for velocity has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No floodgate velocity update neccessary" | /usr/bin/logger -t $MCNAME
   rm floodgate-velocity.jar
  fi
 fi
 fi
fi

# Geyser for Proxy
if [[ $ASOFTWARE == "BUNGEECORD" ]] || [[ $ASOFTWARE == "VELOCITY" ]] || [[ $ASOFTWARE == "WATERFALL" ]] && [[ $BESUPPORT == "TRUE" ]]; then
 cd $LPATH/plugins || exit 1
 mkdir -p $LPATH/mcsys/geyser
 cd $LPATH/mcsys/geyser || exit 1
 if [ $ASOFTWARE = "BUNGEECORD" ] || [ $ASOFTWARE = "WATERFALL" ]; then
 wget -q https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/bungeecord/target/Geyser-BungeeCord.jar -O Geyser-BungeeCord.jar
 unzip -qq -t Geyser-BungeeCord.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded Geyser Bungeecord and Waterfall is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  if [ -f $LPATH/plugins/Geyser-BungeeCord.jar ]; then
   echo "Geyser-BungeeCord.jar plugin exists" | /usr/bin/logger -t $MCNAME
  else
   touch $LPATH/plugins/Geyser-BungeeCord.jar
  fi
  diff -q Geyser-BungeeCord.jar $LPATH/plugins/Geyser-BungeeCord.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
  cp Geyser-BungeeCord.jar Geyser-BungeeCord.jar."$(date +%Y.%m.%d.%H.%M.%S)"
  mv Geyser-BungeeCord.jar $LPATH/plugins/Geyser-BungeeCord.jar
  /usr/bin/find $LPATH/mcsys/geyser/* -type f -mtime +6 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   echo "Geyser for Bungeecord and Waterfall has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No Geyser-BungeeCord.jar update neccessary" | /usr/bin/logger -t $MCNAME
   rm Geyser-BungeeCord.jar
  fi
 fi
 fi
# Velocity part
 if [[ $ASOFTWARE == "VELOCITY" ]]; then
 wget -q https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/velocity/target/Geyser-Velocity.jar -O Geyser-Velocity.jar
 unzip -qq -t Geyser-Velocity.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded Geyser-Velocity is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  if [ -f $LPATH/plugins/Geyser-Velocity.jar ]; then
   echo "Geyser-Velocity.jar plugin exists" | /usr/bin/logger -t $MCNAME
  else
   touch $LPATH/plugins/Geyser-Velocity.jar
  fi
  diff -q Geyser-Velocity.jar $LPATH/plugins/Geyser-Velocity.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
  cp Geyser-Velocity.jar Geyser-Velocity.jar."$(date +%Y.%m.%d.%H.%M.%S)"
  mv Geyser-Velocity.jar $LPATH/plugins/Geyser-Velocity.jar
  /usr/bin/find $LPATH/mcsys/geyser/* -type f -mtime +6 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   echo "Geyser for Velocity has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No Geyser-Velocity.jar update neccessary" | /usr/bin/logger -t $MCNAME
   rm Geyser-Velocity.jar
  fi
 fi
 fi
fi

# Error for Mod Servers
if [[ $ASOFTWARE == "FORGE" ]] || [[ $ASOFTWARE == "MOHIST" ]] || [[ $ASOFTWARE == "FABRIC" ]] || [[ $ASOFTWARE == "MINECRAFT" ]] && [[ $BESUPPORT == "TRUE" ]]; then
echo -e "Bedrock support doesn't work on this software! Please use an other sofware or disable Bedrock support."
fi

# Stop Bedrock edition part
# Starting server
cd $LPATH || exit 1

echo "Starting $LPATH/$MCNAME.jar" | /usr/bin/logger -t $MCNAME
if [[ $ASOFTWARE == "PAPER" ]] || [[ $ASOFTWARE == "PURPUR" ]] || [[ $ASOFTWARE == "MOHIST" ]] || [[ $ASOFTWARE == "SPIGOT" ]] || [[ $ASOFTWARE == "BUKKIT" ]]; then
 screen -d -m -L -S $MCNAME  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar $MCNAME.jar nogui"
 exit 0
fi
if [[ $ASOFTWARE == "VELOCITY" ]] || [[ $ASOFTWARE == "BUNGEECORD" ]]; then
 screen -d -m -L -S $MCNAME  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -XX:MaxInlineLevel=15 -jar $MCNAME.jar"
 exit 0
fi
exit 1
