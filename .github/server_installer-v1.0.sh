#!/bin/bash
# Minecraft Server installer for Easy Setup
# Made By CrazyCloudCraft - Argantiu GmbH
MCINSTALLERV=v1.0
MCSETUPVERSION=2.5.2.2
VMCSETUPVERSION=v2.5.2.2
wget -q https://github.com/CrazyCloudCraft/minecraft-bashs/releases/download/"$VMCSETUPVERSION"/server-start-scripts-"$VMCSETUPVERSION".zip
rm server-start-scripts-"$VMCSETUPVERSION".zip
# apt-get -qq install zip
# unzip -qq server-start-scripts-"$MCSETUPVERSION".zip
wget -q https://raw.githubusercontent.com/CrazyCloudCraft/minecraft-bashs/master/update-"$MCSETUPVERSION"/restart.sh -O restart.sh
wget -q https://raw.githubusercontent.com/CrazyCloudCraft/minecraft-bashs/master/update-2.5.2.2/stop.sh -O stop.sh
wget -q https://raw.githubusercontent.com/CrazyCloudCraft/minecraft-bashs/master/update-2.5.2.2/start.sh -O start.sh
chmod +x stop.sh
chmod +x start.sh
chmod +x restart.sh
apt-get -qq install joe
# rm server-start-scripts-"$MCSETUPVERSION".zip
echo -e "\033[1;32m__________"
echo -e "\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m Setup finished!"
echo -e "\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m Please edit now the start.sh files with joe start.sh"
sleep 3
# rm server_installer-"$MCINSTALLERV".sh
exit 1
