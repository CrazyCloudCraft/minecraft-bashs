# Server scripts to start or stop a Minecraft PaperMC server
Start, stop and restart scripts for your Minecraft server using PaperMC for native use or use in systemd with Debian.  
**Hey, we will make a big update soon so please just wait for the update.**
### What can I do with this?
These scripts won't only restart or stop and start your server.  
Furthermore these scripts can create backups, keep your Paper up to date and provide plugin updates for GeyserMC and Floodgate. (You can also disable this).
#### What you need to use the bash files:
- You need a Minecraft [PaperMC](https://papermc.io) or [PurPur](https://purpurmc.org) server runnig in `/opt/`
- You need a subfolder in your Minecraft Server folder called jar (Command: `mkdir jar`)
- And you also need this addons:  
`apt-get install screen` - screen to see  
`apt-get install sudo` - sudo is sudo  
`apt-get install zip` - zip to zip or unzip something  
`apt-get install wget` - wget to upload files (like plugins)  
`apt-get install findutils` - [Essentials](https://wiki.ubuntuusers.de/xargs/) Package  
`apt-get install diffutils` - Yes this too  
  
`dpkg -l | grep <package name>` - to see if you have the package  

### How to install this?

You can just put the files into your server files (where also your `server.propeties` are)  
You can use this command: `wget https://github.com/CrazyCloudCraft/minecraft-bashs/releases/download/minecraft-server-assets-v2.3/server-start-scripts-v2.3.zip`  
Or `wget https://t1p.de/zceh` (easyer)  
And config this files with `joe start.sh` / `joe stop.sh` or `joe restart.sh` you can close zhe files with `strg + k + x` on your keyboard.  
  
You need `joe` istalled to edit those: `apt-get install joe`  
  
  
## ------------------------------------------------
### Update V2.3
The scripts has now more features!  
  
You can set your software PaperMC, PurPurMC, or for Proxy Velocity  
- It's now easyer to configure the files!  
- You can now tranzlate your messages in your language. (default language is english)  
  
This feature may come in the future:  
- Only one configuration file, with easyer configuration.  
- Spigot and Bungeecord support. (Bukkit will never supported here, only if many people ask.)  
  
  
## ------------------------------------------------
  
- [X] Writing readme
- [X] Uplad files
- [X] Update files to 2.1 (for easyer configuring & bugg fixes)
