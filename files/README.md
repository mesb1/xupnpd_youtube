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

  If you want your own server you can build it with this.
   
  This file allow get video by plugin for your dlna clients, it receives video id and quality info from xupnpd, gets right url and starts stream from https to http for xupnpd.
  
  You can join for development here ot get updated version:
  https://github.com/mejgun/yt-proxy
  
  It uses youtube-dl project too. You need get updated version for yourself.
  
  Example:
  
   - Get server: centos 6 32 bit was cheapest vm we can get. (at first look minimal centos 7 x64 works fine too)
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
  
## yt-dlp

  Another great project, please get updated one for yourself: https://github.com/yt-dlp/yt-dlp/
  As you might already know, something is wrong with development process of youtube-dl, so yt-dlp forked now.
  You can place and rename it's executable file instead of original youtube-dl and it should work out of the box.
  Also it uses atleast python 3.6, so take care of it. Sometimes you might need to edit file to replace its header from python to python3.6 for some systems.
  
## xupnpd_web2m3u.sh

  Useful script for devices that can play direct m3u links, but know nothing about dlna, so can't use xupnpd directly.
  Script for generating m3u playlist witl url to youtube playlist items. You can add it into crontab and fix it for path and playlist name.
  Today we have lots of cheap dvb-t2/c receivers on the market, it supports IPTV via lan or wifi. (selenga hd980d, world vision t625a lan, etc)
  With every run, it generate m3u list directly available for such tuners.
  Technically, xupnpd used as web server and provider of initial list for converting.
