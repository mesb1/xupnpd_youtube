
# Todo

## Tech misc

  Main problem, is that usually xupnpd builded without ssl support, so you cannot use it for direct youtube watching as yt switched to https completely.
  
  So this plugin version uses external server that does getting right url and proxyfying from https to http stream.
  
  We cannot use router for youtube-dl, because of high resource usage, but there is still things that can be done better!
  
  That would be great to change plugin to use curl with ssl support to play https stream from youtube directly and allow external server only gets right url, as youtube-dl needs much resources for its work.
  But we shoud avoid youtube-dl faq: https://github.com/ytdl-org/youtube-dl#i-extracted-a-video-url-with--g-but-it-does-not-play-on-another-machine--in-my-web-browser
  
  
