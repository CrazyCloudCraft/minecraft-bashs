<p align="center">
    <img src="https://crazycloudcraft.de/wp-content/uploads/2021/04/cropped-crazycloudcraft-icon-server.png" width="150">
</a>
<p align="center">
    <a href="https://github.com/CrazyCloudCraft/minecraft-bashs/releases">
        <img src="https://img.shields.io/github/v/release/CrazyCloudCraft/minecraft-bashs?color=%2350AFFF&label=latest%20release&logo=FutureLearn&logoColor=50AFFF&style=flat-square" />
    </a>
    <a href="https://github.com/CrazyCloudCraft/minecraft-bashs/releases">
        <img src="https://img.shields.io/github/downloads/CrazyCloudCraft/minecraft-bashs/total?color=green&label=Downloads&logo=GitHub&logoColor=74FF00&style=flat-square" />
    </a>
  
[![Codacy Security Scan](https://github.com/CrazyCloudCraft/minecraft-bashs/actions/workflows/codacy.yml/badge.svg?branch=master)](https://github.com/CrazyCloudCraft/minecraft-bashs/actions/workflows/codacy.yml) 
### Shell scripts to run your Mineraft server very well
Shell scripts for your Minecraft server for managing in native or systemd use with Debian or Ubuntu.    

---
### Supported Software  
| Type | Software
|-----------------------------------------------------------------------|-----------------------------------------------------------------------|
| Server  | [PurpurMC](https://purpurmc.org) 
| Server  | [PaperMC](https://papermc.io)         
| Proxy   | [Velocity](https://velocitypowered.com) 
| Proxy   | [Bungeecord](https://spigotmc.org)  
| Modded  | [MohistMC](https://mohistmc.com)  
---
### What can I do with this?
These scripts won't only restart or stop and start your server.  
Furthermore these scripts can create backups, keep your Software up to date and provide plugin updates for e.g. GeyserMC and Floodgate.
  
#### What you need to use the bash files:
You need java to run the server you can [get a repository here](https://www.azul.com/downloads/?package=jdk)  
The v2.5 scripts installs everything (exept for java) what they need to work.  
  
---
### How to install this?

You can take the [difficult way here](https://github.com/CrazyCloudCraft/minecraft-bashs/blob/master/.github/setup.md)  
Or you take the  
## Easy Setup
Combiend command: 
```
wget -q https://github.com/CrazyCloudCraft/minecraft-bashs/releases/download/v2.5.1.1/server-start-scripts-v2.5.1.1.zip && apt-get install zip && unzip server-start-scripts-*.zip && chmod +x *.sh && apt-get install joe && rm server-start-scripts-*.zip
```
Then Edit the files with `joe start.sh` , `joe stop.sh` , `joe restart.sh`
After that, you are ready to start with `./start.sh`
  
### Support  
  
If you need setup help, or want to add features that aren't listed here  
please just write an [issue](https://github.com/CrazyCloudCraft/minecraft-bashs/issues) ! (Discord will be added soon)
    
[More stats](https://github.com/CrazyCloudCraft/minecraft-bashs/blob/master/.github/all-stats.md)
