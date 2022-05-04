#!/bin/bash
ASOFTWARE=VELOCITY
BEDROCKSUPPORT=TRUE

if [ "$ASOFTWARE" = "PAPER" ] && [ "$BEDROCKSUPPORT" = "TRUE" ]; then
cd $LPATH/floodgate
wget -q https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/spigot/target/floodgate-spigot.jar 
fi
