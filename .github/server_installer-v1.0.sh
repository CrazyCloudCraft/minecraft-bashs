#!/bin/bash
# Minecraft Server installer for Easy Setup
# Made By CrazyCloudCraft - Argantiu GmbH
MCINSTALLERV=v1.0
MCSETUPVERSION=v2.5.2.2
wget -q https://github.com/CrazyCloudCraft/minecraft-bashs/releases/download/"$MCSETUPVERSION"/server-start-scripts-"$MCSETUPVERSION".zip 
apt-get -qq install zip
unzip -qq server-start-scripts-"$MCSETUPVERSION".zip
chmod +x stop.sh
chmod +x start.sh
chmod +x restart.sh
apt-get -qq install joe
rm server-start-scripts-"$MCSETUPVERSION".zip
echo -e "\033[1;32m__________"
echo -e "\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m Setup finished!"
echo -e "\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m Please edit now the .sh files with joe <file>.sh"
rm server_installer-"$MCINSTALLERV".sh
exit 1
