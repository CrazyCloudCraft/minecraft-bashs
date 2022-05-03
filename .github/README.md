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
  
### Server scripts to start or stop a Minecraft server
Start, stop and restart scripts for your Minecraft server for native use or use in systemd with Debian or Ubuntu.  
  

---
### Supported Software  
| Type | Software
|-----------------------------------------------------------------------|-----------------------------------------------------------------------|
| Server   | [PurpurMC](https://purpurmc.org) 
| Server | [PaperMC](https://papermc.io)         
| Proxy     | [Velocity](https://velocitypowered.com) 
| Proxy         | [Bungeecord](https://spigotmc.org)  
| Modded        | [MohistMC](https://mohistmc.com)  
---
### What can I do with this?
These scripts won't only restart or stop and start your server.  
Furthermore these scripts can create backups, keep your Software up to date and provide plugin updates for e.g. GeyserMC and Floodgate.
  
#### What you need to use the bash files:
You need one of the Minecraft Software types or you didn't need anything.  
The v2.5 scripts installs everything (exept for java) what they need to work.  
  
---
### How to install this?

You can just put the files into your server files (where also your `server.propeties` are or will be)  
You can use this command:  
`wget https://github.com/CrazyCloudCraft/minecraft-bashs/releases/download/v2.5.1.1/server-start-scripts-v2.5.1.1.zip`  
To unzip it use unzip:
`unzip server-start-scripts-v2.5.zip`  
And config this files with `joe start.sh` / `joe stop.sh` or `joe restart.sh` you can close (and save) the files with `strg + k + x` on your keyboard.  
  
You probably need `joe` istalled to edit those: `apt-get install joe`  
    
After that you just type in: `chmod +x *.sh`  
    
And after that you can start/stop or restart your server with `./start.sh` , `./stop.sh` or `restart.sh`
  
### Support  
  
If you need setup help, or want to add features that aren't listed here  
please just write an [issue](https://github.com/CrazyCloudCraft/minecraft-bashs/issues) ! (Discord will be added soon)
  
---
### Todo list
- [x] √ Add support for PaperMC   
- [x] √ Add support for PurPurMC  
- [x] √ Add support for VelocityMC  
- [x] √ Add support for MohistMC  
- [x] √ Add support for Bungeecord  
- [ ] Add support for SpigotMC  
- [ ] Add support for WaterfallMC  
- [ ] Add support for Minecraft  
- [ ] Add support for Forge  
- [ ] Add support for Fabric  
- [x] √ Add backup system  
- [ ] Fixing backup system  
- [ ] Add new backup system to save it fast and simple  
- [ ] repair bedrock support   
- [ ] adding plugin updater  
- [ ] Add support for Windows user  
