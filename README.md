# xupnpd_youtube fixed plugin for xupnpd v1
  Fixed plugin from third party developers, thanks to everyone who let this piece of software to be.
  

## Features

  Get video by:
  - name from http://www.youtube.com/user/name 
  - id from http://www.youtube.com/channel/id
  - favorites/username 
  - favorites/id
  - playlist/id
  - search/search_string/optional[region](https://www.iso.org/iso-3166-country-codes.html)/optional[language(ISO 639-1 Code)](http://www.loc.gov/standards/iso639-2/php/code_list.php)
  - YouTube channels: channel/mostpopular/optional[region](https://www.iso.org/iso-3166-country-codes.html)
  - Uses youtube api v3

  
### Tech

  You can get xupnpd from github or via repo for you device. Usually it can be founded inside openwrt, entware repos.
  
  Plugin can get video only 360p or 720p. If you have bad internet, choose 360p.

  Required minimal: 
   - Curl with ssl support.
   - Replace plugin file inside xupnpd plugin directory.
   - Get API key from google developers console: https://console.developers.google.com
   - Replace *** with your new key in section &key=*** inside plugin file. Save file.
   - Restart xupnpd, remove any old feeds that was made for youtube earlier. Add new one based on ui help patterns.

  Optional:
   - Plugin uses third party server to get video and retransmit it to your dlna clients.
   - You may use it as is, or start your own server, check [README.md](https://github.com/mesb1/xupnpd_youtube/blob/master/files/README.md) inside files dir.

### Links

  - [xupnpd](https://github.com/clark15b/xupnpd)
  

### Feedback

  - [Zyxmon Forum](http://forums.zyxmon.org/viewtopic.php?f=5&t=31)
  
  
### Policy

  - [Here is policy](https://github.com/mesb1/xupnpd_youtube/blob/master/POLICY.md)
 

