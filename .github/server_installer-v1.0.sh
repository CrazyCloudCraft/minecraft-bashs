#!/bin/bash
# Minecraft Server installer for Easy Setup
# Made By CrazyCloudCraft - Argantiu GmbH
wget -q https://github.com/CrazyCloudCraft/minecraft-bashs/releases/download/v2.5.1.1/server-start-scripts-v2.5.1.1.zip 
apt-get -qq install zip
unzip -qq server-start-scripts-v2.5.1.1.zip
chmod +x stop.sh
chmod +x start.sh
chmod +x restart.sh
apt-get -qq install joe
rm server-start-scripts-v2.5.1.1.zip
echo -e "\033[1;32m__________"
echo -e "\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m Setup finished!"
echo -e "\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m Please edit now the .sh files with joe <file>.sh"
rm server_installer-v1.0.sh
exit 1
