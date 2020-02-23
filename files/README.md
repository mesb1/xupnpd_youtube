# Tech info
  Here is info how to work with this files.
  

## xupnpd_youtube

  Install:
  
  - Install xupnpd v1.
  - Install curl with ssl support.
  - Replace plugin file inside xupnpd plugin directory.
  - Get API key from google developers console: https://console.developers.google.com
  - Replace *** with your new key in section '&key=' inside plugin file. Save file.
  - Restart xupnpd, remove any old feeds that was made for youtube earlier. Add new one based on ui help patterns.
  - You are ready to go.
  
  
## yt-proxy

  This file allow get video by plugin for your dlna clients, it receives video id and quality info from xupnpd, gets right url and starts stream from https to http for xupnpd.
  
  If you want your own server you can build it with this.
  
  It uses youtube-dl project too. You need get updated version for yourself.
  
  Example:
  
   - Get server: centos 6 32 bit was cheapest vm we can get.
   - Run: yum update
   - Install screen: yum install screen
   - Run: curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
   - Run youtube-dl to check its ok or maybe need some additional packages.
   - Put yt-proxy and corrupted.mp4 to filesystem.
   - Login to server, run screen, inside screen run yt-proxy like this: ./yt-proxy 8484 and detach from screen.
   - Check firewall settings for port 8484 tcp to be open.
   - Change 2 server address inside xupnpd_youtube file section: videourl =
   - Restart xupnpd.
  
  
## youtube-dl

  Great project, please get updated one for yourself, it is used with yt-proxy only: http://yt-dl.org/
