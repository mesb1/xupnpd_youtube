# Tech info
  Here is info how to work with this files.
  

## xupnpd_youtube

  Install:
  
  - Install xupnpd v1.
  - Install curl with ssl support.
  - Place plugin file into xupnpd plugin directory.
  - Get API key from google developers console: https://console.developers.google.com
  - Replace *** with your new key in section '&key=' inside plugin file. Save file.
  - Restart xupnpd, remove any old feeds that was made for youtube earlier. Add new one based on ui help patterns.
  
  
## yt-proxy

  This file allow get video by plugin for your dlna clients.
  
  If you want your own server you can build it with this.
  
  It uses youtube-dl project too. You need get updated version for yourself.
  
  Example:
  
   - Get server: centos 6 32 bit was cheapest vm we can get.
   - Run: yum update
   - Install screen: yum install screen
   - Run https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
   - Run youtube-dl to check its ok or maybe need some additional packages.
   - Put yt-proxy to filesystem.
   - Login to server, run screen, inside screen run yt-proxy like this: 
  
  
