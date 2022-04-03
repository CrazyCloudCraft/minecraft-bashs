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
    <a href="https://github.com/CrazyCloudCraft/minecraft-bashs/wiki">
        <img src="https://img.shields.io/appveyor/build/CrazyCloudCraft/minecraft-bashs?style=flat-square" />
    </a>
    <a href="main">
        <img src="https://img.shields.io/github/commits-since/CrazyCloudCraft/minecraft-bashs/v2.5.0/master?color=DDFF50&label=commits&logo=GitHub&style=flat-square" />
    </a>
  
--- 
### Server scripts to start or stop a Minecraft server
Start, stop and restart scripts for your Minecraft server for native use or use in systemd with Debian.  
  
---
### Supported Software  
With fast performance:  
(Server) [PurpurMC](https://purpurmc.org)  
(Server) [PaperMC](https://papermc.io)  
(Proxy) [Velocity](https://velocitypowered.com)  

With slow performance:  
(Proxy) [Bungeecord](https://spigotmc.org)  
  
Modificated (Plugins & Forge Mods):  
(Server) [MohistMC](https://mohistmc.com)  
  
---
### What can I do with this?
These scripts won't only restart or stop and start your server.  
Furthermore these scripts can create backups, keep your Software up to date and provide plugin updates for e.g. GeyserMC and Floodgate.
  
#### What you need to use the bash files:
You need one of the Minecraft Software types runnig in `/opt/` or you didn't need anything.  
The v2.5 scripts installs everything what they need to work.  
  
### How to install this?

You can just put the files into your server files (where also your `server.propeties` are)  
You can use this command: `wget https://github.com/CrazyCloudCraft/minecraft-bashs/releases/download/minecraft-server-assets-v2.5/server-start-scripts-v2.5.zip`  
And config this files with `joe start.sh` / `joe stop.sh` or `joe restart.sh` you can close (and save) the files with `strg + k + x` on your keyboard.  
  
You probably need `joe` istalled to edit those: `apt-get install joe`  
  
