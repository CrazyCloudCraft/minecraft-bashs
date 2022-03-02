#!/bin/bash
# Minecraft Server start/stop configuration - Check if server is already started
# Version 2.3-dev.1 made by CrazyCloudCraft 02.03.2022 https://crazycloudcraft.de 

# Configuration:
# Define your Minecraft version like 1.17, 1.17.1, 1.18, 1.18.1 based on PaperMC and PurPurMC
# For Velocity you set the latest PROXY version ( in the moment: 3.1.1 )
MAINVERSION=1.18.1
# What type of Server Software do you use? 
# You can use: PAPER , PURPUR , MOHIST , SPIGOT 
# And for Proxy: VELOCITY , BUNGEE
ASOFTWARE=PAPER
# Set your folder where the subfolders of your server shall run
OPTBASE=opt
# Set your server folder where your server shall run
SERVERBASE=Paper
# Backups go here underneath BPATH
BPATH=Paper_backups
# Do you need a Backup ? BACKUP=TRUE
BACKUP=FALSE
# What jar and screen name shall your Minecraft server have?
MCNAME=paper
# Amount of RAM that your Mincecraft server will use (M or G) e.g.: RAM=2024M or RAM=10G
RAM=5G
# Name of your java executable (Default java) e.g.: JAVABIN=/usr/bin/java
JAVABIN=java17
#Minecraft Bedrock (PE)
# Do you need Floodgate?
UPDATEFLOOD=TRUE
# Do you need Geyser? (Only on PurPur and Paper standalone)
UPDATEGEYSER=FALSE
# Do you need Geyer on Velocity? (Proxy) 
# (Floodgate must bee enabled by the standalone servers)
PRUPDATEGEYSER=FALSE


# Only Variables DO NOT EDIT THIS or your server may be deleted
export RAM
./start.sh

