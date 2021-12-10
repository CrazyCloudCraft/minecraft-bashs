# Server scripts to start or stop an Minecraft server
Start, stop and restart scripts for your Minecraft server using PaperMC.
  
### What can I do with this?
This scripts don't only restart or stop and start your server.  
This scripts can create backups and plugin updates for GeyserMC and Floodgate. (You can also disable this).
#### What you need to use the bash files:
- You need an Minecraft [PaperMC](https://papermc.io) server runnig in `/opt/`
- You need an folder in your Minecraft Server called jar (Command: `mkdir jar`)
- And you also need this addons:  
`apt-get install screen` - screen to see  
`apt-get install sudo` - sudo is sudo  
`apt-get install zip` - zip to zip or unzip something  
`apt-get install wget` - wget to upload files (like plugins)  
`apt-get install findutils` - [Essentials](https://wiki.ubuntuusers.de/xargs/) Package  
`apt-get install diffutils` - Yes this too  
  
`dpkg -l | grep <package name>` - to see if you have the package  

### How to install this?
You can just put the files into your server files (where also your `server.properties` are)  
And config this files with `joe start.sh` / `joe stop.sh` or `joe restart.sh` you can close zhe files with strg + k + x on your keyboard.  
  
You need `joe` istalled to edit those: `apt-get install joe`  
  
  
- [X] Writing readme
- [X] Uplad files
- [X] Update files to 2.1 (for easyer configuring)
