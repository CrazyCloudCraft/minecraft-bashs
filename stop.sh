#!/bin/bash
# Minecraft Server auto stop script - 
# Made by CrazyCloudCraft 08.12.2021 https://crazycloudcraft.de
# Configuration:

# What jar and screen name does your Minecraft Server have?
MCNAME=paper
# The Messages displayed name. - Does not matter what you write here.
DISPLAYNAME=Paper

# Tranzlations:
# Stopping Message Tranzlation:
MESSAGESTOP=Server is stopping in
# Message time Tranzlation:
DISPLAYTRANZTIME=seconds



# Script start. Do not configure this!

if ! screen -list | grep -q "$MCNAME "; then
  echo "Server is not currently running!"
  exit 1
fi

# Stop the server[A
echo "Notification: Stopping $DISPLAYNAME server ..."
echo "Notification: Stopping $DISPLAYNAME server ..." | /usr/bin/logger -t $MCNAME

# Start countdown notice on server
screen -Rd $MCNAME -X stuff "say Server is stopping...$(printf '\r')"
#screen -Rd $MCNAME -X stuff "say $MESSAGESTOP 30 $DISPLAYTRANZTIME ! $(printf '\r')"
#sleep 20s
screen -Rd $MCNAME -X stuff "say $MESSAGESTOP 10 $DISPLAYTRANZTIME ! $(printf '\r')"
sleep 1s
screen -Rd $MCNAME -X stuff "say $MESSAGESTOP 9 $DISPLAYTRANZTIME ! $(printf '\r')"
sleep 1s
screen -Rd $MCNAME -X stuff "say $MESSAGESTOP 8 $DISPLAYTRANZTIME ! $(printf '\r')"
sleep 1s
screen -Rd $MCNAME -X stuff "say $MESSAGESTOP 7 $DISPLAYTRANZTIME ! $(printf '\r')"
sleep 1s
screen -Rd $MCNAME -X stuff "say $MESSAGESTOP 6 $DISPLAYTRANZTIME ! $(printf '\r')"
sleep 1s
screen -Rd $MCNAME -X stuff "say $MESSAGESTOP 5 $DISPLAYTRANZTIME ! $(printf '\r')"
sleep 1s
screen -Rd $MCNAME -X stuff "say $MESSAGESTOP 4 $DISPLAYTRANZTIME ! $(printf '\r')"
sleep 1s
screen -Rd $MCNAME -X stuff "say $MESSAGESTOP 3 $DISPLAYTRANZTIME ! $(printf '\r')"
sleep 1s
screen -Rd $MCNAME -X stuff "say $MESSAGESTOP 2 $DISPLAYTRANZTIME ! $(printf '\r')"
sleep 1s
screen -Rd $MCNAME -X stuff "say $MESSAGESTOP 1 $DISPLAYTRANZTIME ! $(printf '\r')"
sleep 1s
screen -Rd $MCNAME -X stuff "say Server stoppt...$(printf '\r')"
echo "Closing Server..."
screen -Rd $MCNAME -X stuff "Stop$(printf '\r')"

# Wait up to 20 seconds for server to close
StopChecks=0
while [ $StopChecks -lt 30 ]; do
  if ! screen -list | grep -q "$MCNAME "; then
    break
  fi
  sleep 1;
  StopChecks=$((StopChecks+1))
done

# Force quit if server is still open
if screen -list | grep -q "$MCNAME "; then
  echo "$DISPLAYNAME server still hasn't closed after 30 seconds, closing screen explicit"  | /usr/bin/logger -t $MCNAME
  screen -S $MCNAME -X quit
  pkill -15 -f "SCREEN -dmSL $MCNAME"
fi

echo "Minecraft server $DISPLAYNAME stopped."
echo "Minecraft server $DISPLAYNAME stopped." | /usr/bin/logger -t $MCNAME

