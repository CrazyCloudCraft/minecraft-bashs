#!/bin/bash
ASOFTWARE=VELOCITY
BEDROCKSUPPORT=TRUE

if [ $ASOFTWARE = "PAPER" "SPIGOT" ] && [ $BEDROCKSUPPORT = "TRUE" ]; then
cd "$LPATH"/floodgate || exit && echo "Error #0001"
wget -q https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/spigot/target/floodgate-spigot.jar 
fi
