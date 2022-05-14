You can just put the files into your server files (where also your `server.propeties` are or will be)  
You can use this command:  
```
wget https://github.com/CrazyCloudCraft/minecraft-bashs/releases/download/v2.5.1.1/server-start-scripts-v2.5.1.1.zip
```  
To unzip it use unzip:
```unzip server-start-scripts-v2.5.zip```  
And config this files with ```joe start.sh``` / ```joe stop.sh``` or ```joe restart.sh``` you can close (and save) the files with `strg + k + x` on your keyboard.  
  
You probably need `joe` istalled to edit those: ```apt-get install joe```  
    
After that you just type in:
```
chmod +x *.sh
``` 
    
And after that you can start/stop or restart your server with ```./start.sh``` , ```./stop.sh``` or ```./restart.sh```

[<- Back](github.com/CrazyCloudCraft/minecraft-bashs)
