#!/usr/bin/env bash
## Settings and config options
BUILD_DIR="/home/minecraft/buildtools-edge";
BUILD_JSON_PATH="$BUILD_DIR/BuildData/info.json";
MULTICRAFT_JARS_DIR="/home/minecraft/multicraft/jar";
MULTICRAFT_JARS_DIR_CHOWN="minecraft:minecraft";
WWW_JARS_DIR="/var/www/vhosts/panel.lumengaming.com/httpdocs/downloads";
WWW_JARS_URL="https://panel.lumengaming.com/downloads";
WWW_JARS_DIR_CHOWN="panel_lumen:psaserv";
BUILDTOOLS_URL="https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar";
BUNGEE_URL="http://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar";
SKIP_COMPILE=true;
SKIP_DEPLOY=false;
## ============================================================================================= ##
## Build the spigot jar files
cd $BUILD_DIR;
if ${SKIP_COMPILE}; then
    echo 'Skipping the compile step.';
else
    echo 'Compiling the spigot jars.';
    rm ./spigot-*.jar;
    wget -O $BUILD_DIR/BuildTools.jar $BUILDTOOLS_URL;
    git config --global --unset core.autocrlf;
   
    # Build, and also ONLY show errors. Do not show output.
    java -jar BuildTools.jar --dev > /dev/null;
fi
## Detect version. (Requires JQ if you do not already have it. sudo apt-get install jq)
VERSION=`jq -r '.minecraftVersion' $BUILD_JSON_PATH`; # 1.43.2 or something
echo "Spigot version $VERSION detected.";
## DEPLOY to WWW directory
if ${SKIP_DEPLOY}; then
    echo 'Skipping the deploy step.';
else
    echo 'Deploying the jars to the web directory.';
    rm $BUILD_DIR/spigot*.jar;
    rm $WWW_JARS_DIR/spigot-*$VERSION.jar;
    echo "Moving spigot-api-shaded-$VERSION.jar to WWW dir.";
    cp $BUILD_DIR/Spigot/Spigot-API/target/spigot-api-*shaded.jar ./spigot-api-shaded-$VERSION.jar;
    cp ./spigot-api-shaded-$VERSION.jar $WWW_JARS_DIR/spigot-api-shaded-$VERSION.jar;
 
    echo "Moving spigot-api-$VERSION.jar to WWW dir.";
    cp $BUILD_DIR/Spigot/Spigot-API/target/spigot-api-*SNAPSHOT.jar ./spigot-api-$VERSION.jar;
    cp ./spigot-api-$VERSION.jar $WWW_JARS_DIR/spigot-api-$VERSION.jar;
 
    echo "Moving spigot-$VERSION.jar to WWW dir.";
    cp $BUILD_DIR/Spigot/Spigot-Server/target/spigot-*.jar ./spigot-$VERSION.jar;
    cp ./spigot-$VERSION.jar $WWW_JARS_DIR/spigot-$VERSION.jar;
    echo "Downloading latest build tools";
    wget -O $WWW_JARS_DIR/BungeeCord.jar $BUNGEE_URL;
 
    echo "Chowning the files in the WWW dir.";
    chown $WWW_JARS_DIR_CHOWN $WWW_JARS_DIR/spigot-api-shaded-$VERSION.jar;
    chown $WWW_JARS_DIR_CHOWN $WWW_JARS_DIR/spigot-api-$VERSION.jar;
    chown $WWW_JARS_DIR_CHOWN $WWW_JARS_DIR/spigot-$VERSION.jar;
    chown $WWW_JARS_DIR_CHOWN $WWW_JARS_DIR/BungeeCord.jar;
fi
CONF_PATH="$MULTICRAFT_JARS_DIR/spigot-${VERSION}.jar.conf";
JAR_PATH="$MULTICRAFT_JARS_DIR/spigot-${VERSION}.jar";
## Generate configs for multicraft
CONFIG_CONTENT="## Multicraft config for spigot version: ${VERSION}\\n\\n";
CONFIG_CONTENT+="[config]\\n";
CONFIG_CONTENT+="name = Mod: Spigot (${VERSION})\\n\\n";
CONFIG_CONTENT+="source = $WWW_JARS_URL/spigot-${VERSION}.jar\\n";
CONFIG_CONTENT+="configSource = $WWW_JARS_URL/spigot-${VERSION}.jar.conf\\n\\n";
CONFIG_CONTENT+="[encoding]\\n";
CONFIG_CONTENT+="#encode = system\\n";
CONFIG_CONTENT+="#decode = system\\n";
CONFIG_CONTENT+="#fileEncoding = latin-1\\n\\n";
CONFIG_CONTENT+="[start]\\n";
CONFIG_CONTENT+="command = \"{JAVA}\" -Xmx{MAX_MEMORY}M -Xms{START_MEMORY}M -Djline.terminal=jline.UnsupportedTerminal -jar \"{JAR}\" nogui\\n";
 
if [ -f "$CONF_PATH" ]; then
    echo "Config for spigot-${VERSION} already exists. :D";
else
    echo "Creating Config for spigot-${VERSION}.";
    echo -e $CONFIG_CONTENT >> $CONF_PATH;
    chown $MULTICRAFT_JARS_DIR_CHOWN $CONF_PATH;
 
    echo -e $CONFIG_CONTENT $WWW_JARS_DIR/spigot-$VERSION.jar.conf >> $WWW_JARS_DIR/spigot-$VERSION.jar.conf;
    chown $WWW_JARS_DIR_CHOWN $WWW_JARS_DIR/spigot-$VERSION.jar.conf;
fi
if [ -f "$JAR_PATH" ]; then
    echo "Jar for spigot-${VERSION} already exists. :D";
else
    echo "Creating dummy jar for spigot-${VERSION}.";
    echo "This file will be replaced when the JAR is updated via multicraft for the first time." >> $JAR_PATH;
    chown $MULTICRAFT_JARS_DIR_CHOWN $JAR_PATH;
fi
echo "FINISHED!";
