<p align="center">
    <img src="https://crazycloudcraft.de/wp-content/uploads/2021/04/cropped-crazycloudcraft-icon-server.png" width="150">
</a>
<p align="center">
    <a href="https://github.com/CrazyCloudCraft/minecraft-bashs/releases">
        <img src="https://img.shields.io/github/v/release/CrazyCloudCraft/minecraft-bashs?color=%2350AFFF&label=latest%20release&logo=FutureLearn&logoColor=50AFFF&style=flat-square" />
    </a>
    <a href="https://github.com/CrazyCloudCraft/minecraft-bashs/releases">
        <img src="https://img.shields.io/github/downloads/CrazyCloudCraft/minecraft-bashs/v2.5.2.2/total?color=green&label=Downloads%20latest&logo=github&logoColor=green&style=flat-square" />
    </a>
  
</a>
        <img src="https://img.shields.io/github/downloads/CrazyCloudCraft/minecraft-bashs/total?color=green&label=All-Downloads&logo=GitHub&logoColor=74FF00&style=flat-square" />
</a>
  
[![Codacy Security Scan](https://github.com/CrazyCloudCraft/minecraft-bashs/actions/workflows/codacy.yml/badge.svg?branch=master)](https://github.com/CrazyCloudCraft/minecraft-bashs/actions/workflows/codacy.yml) 
### Shell scripts to run your Mineraft server very well
Shell scripts for your Minecraft server for managing in native or systemd use with Debian or Ubuntu.    
  
---
### Supported software  
| Type | Software
|-----------------------------------------------------------------------|-----------------------------------------------------------------------|
| Server  | [PurpurMC](https://purpurmc.org) 
| Server  | [PaperMC](https://papermc.io)     
| Server  | [SpigotMC](https://spigotmc.org) (Alpha)
| Server  | [Bukkit](https://dev.bukkit.org/) (Alpha)  
| Proxy   | [Velocity](https://velocitypowered.com) 
| Proxy   | [Bungeecord](https://spigotmc.org)  
| Modded  | [MohistMC](https://mohistmc.com)  
---
### What can I do with this?
These scripts won't only restart or stop and start your server.  
Furthermore these scripts can create backups, keep your software up to date and provide plugin updates for e.g. GeyserMC and Floodgate.
  
#### What you need to use the bash files:
You need java to run the server you can [get a repository here](https://www.azul.com/downloads/?package=jdk)  
The v2.5 scripts installs everything (exept for java) what they need to work.  
  
---
### How to install this?  
Go into your server folders `cd /myservers/server/niceserver/ ...` and paste this:
```
wget -q https://t1p.de/qjqgw -O server_installer-v1.0.sh && chmod +x server_installer-v1.0.sh && ./server_installer-v1.0.sh
```
After that, edit the start.sh file with `joe start.sh` or `nano start.sh`  
And you are ready to start with `./start.sh`  
  
### Support  
  
If you need setup help, or want to add features that aren't listed here  
please just write an [issue](https://github.com/CrazyCloudCraft/minecraft-bashs/issues) ! (Discord will be added soon)
    
<p align="center">
  <a href="https://github.com/CrazyCloudCraft/minecraft-bashs/blob/master/.github/all-stats.md">More stats</a>
</p>
