#!/bin/bash
# Made by CrazyCloudCraft 08.12.2021
# Update v2.0.1 by CrazyCloudCraft 21.1.2022
# Update v2.3.1 by CrazCloudCraft 02.03.2022
echo "Restarts?: $TESTMESSAGE"

# Script start. Do not configure this!
if ! screen -list | grep -q "$MCNAME"; then
    echo "$MTRANZLATION"
    # Start server
    /bin/bash $MPATH/start.sh
    exit 0
fi

# Stop server
/bin/bash $MPATH/stop.sh

# Start server
/bin/bash $MPATH/start.sh
