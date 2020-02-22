--

--[[
README
This is YouTube api v3 plugin for xupnpd.
Be accurate when search for real username or playlist id.
Quickstart:
1. Place this file into xupnpd plugin directory.
2. Go to google developers console: https://console.developers.google.com
3. You need API Key.
4. Try leave everything by default, without restriction.
5. Replace '***' with your new key in section '&key=***' in this file. Save file.
6. Restart xupnpd, remove any old feeds that was made for youtube earlier. Add new one based on ui help patterns.
7. Enjoy!

P.S. Curl is required for https youtube api calls.
P.S.S. If you have low speed internet connection and 720p goes buffering too often, set 360p in web config UI settings for youtube.
In this case server part gives you any available but no more than 360p.
In case any other settings server part gives you max available but not more than 720p, thats normal.
Anyway, you may search for vh=360, maybe set 360-480(usually no mp4 video)-720.


Changelog:

20171027
0. Now this plugin is based on client-server logic and youtube-dl. Just because we tired from lots of changes.
1. Plugin based on Sysmer realization.
2. Mejgun created server part based on youtube-dl and ssl to http proxy.
3. Anleal made some fixes to get plugin working with 3rd party and tests.

20171031
1. Mejgun fixed rewind problems on server side.
2. Mejgun added show corrupted video if there was error extracting direct link to video.
3. Mejgun some other fixes for server part.

20171104
1. Mejgun added ability to server part choose resolution for youtube.
2. Anleal change plugin to add resolution settings back.
3. Anleal added part for different resolution works with server part.
4. Added some documentation inside file.


18 - 360p  (MP4,h.264/AVC)
22 - 720p  (MP4,h.264/AVC) hd
37 - 1080p (MP4,h.264/AVC) hd
82 - 360p  (MP4,h.264/AVC)    stereo3d
83 - 480p  (MP4,h.264/AVC) hq stereo3d
84 - 720p  (MP4,h.264/AVC) hd stereo3d
85 - 1080p (MP4,h.264/AVC) hd stereo3d
]]


function curl( data )
	data = io.popen('curl -k -L -s ' .. '"' .. data .. '"')
	d = data:read('*all')
	--close:data()
	return d
end

cfg.youtube_fmt=22
cfg.youtube_region='*'
cfg.youtube_video_count=2

function youtube_updatefeed(feed,friendly_name)
	local function isempty(s)
		return s == nil or s == ''
	end
	
	local data = nil
	local jsondata = nil
	local uploads = nil
	local tr = nil
	local region = ''
	local lang = ''
	local rc = false

	local num = cfg.youtube_video_count

	local key = '&key=***' -- change *** to your youtube api key from: https://console.developers.google.com
	local c = 'https://www.googleapis.com/youtube/v3/channels?part=contentDetails&forUsername='
	local u = 'https://www.googleapis.com/youtube/v3/channels?part=contentDetails&id='
	local i = 'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId='
	local s = 'https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&order=date&q='
	local cn = 'https://www.googleapis.com/youtube/v3/channels?part=snippet&id='
	local cnu = 'https://www.googleapis.com/youtube/v3/channels?part=snippet&forUsername='
	local pl = 'https://www.googleapis.com/youtube/v3/playlists?part=snippet&id='
	local mp = 'https://www.googleapis.com/youtube/v3/videos?part=snippet&chart=mostPopular'
	local duration = 'https://www.googleapis.com/youtube/v3/videos?part=contentDetails'
	local fordata = ''
	local pagetokenA = ''
	local nextpageA = ''
	local enough = false
	local forfeedn = ''
	local numA = 50 -- show 50 videos per page 0..50 from youtube api v3
	local maxA = '&maxResults=' .. numA
	
    if num < numA then
		maxA = '&maxResults=' .. num
		numA = num
    end
	
	if cfg.youtube_region and cfg.youtube_region~='*' then 
		region='&regionCode='..cfg.youtube_region 
		forfeedn = cfg.youtube_region
	else
		region = ''
		forfeedn = 'worldwide'
	end
 
	feed = string.gsub(feed,'//','/empt/')
	if string.sub(feed,1,7) == 'search/' and string.find(feed,'/',8) then
		if string.sub(feed,string.find(feed,'/',8),string.find(feed,'/',8)+5) == '/empt/' then
			feed = string.gsub(feed,'/empt/','/'..forfeedn..'/',1)
		end
	end
	if (string.sub(feed,1,7) == 'search/' and string.find(feed,'/',8) == nil) or (string.sub(feed,1,8) == 'channel/' and string.find(feed,'/',9) == nil) then
		feed = feed..'/'..forfeedn
	end
	local tfeed = split_string(feed,'/')
	local feed_name = formatfeedn(feed)

	if table.getn(tfeed) == 1 then
		data = curl(c .. tfeed[1].. key)
		if string.find(data,'"totalResults": 0,') then
			data = curl(u .. tfeed[1].. key)
			feed_name = curl(cn .. tfeed[1].. key)
		else
			feed_name = curl(cnu .. tfeed[1].. key)
		end
		feed_name = json.decode(feed_name)
		feed_name=formatfeedn(feed_name['items'][1]['snippet']['title'])
		jsondata = json.decode(data)
		uploads = jsondata['items'][1]['contentDetails']['relatedPlaylists']['uploads']
		fordata = i .. uploads .. key
	end

	if table.getn(tfeed) > 1 then
		if tfeed[3] and tfeed[3]~='worldwide' then
			region = '&regionCode='..string.upper(tfeed[3])
		end
		if tfeed[4] then
			lang = '&relevanceLanguage='..string.lower(tfeed[4])
		end
		if tfeed[1] == 'search' then
			fordata = s .. util.urlencode(tfeed[2]) .. key .. '&videoDefinition=high&videoDimension=2d' .. region .. lang
		end

		if tfeed[1] == 'playlist' then
			fordata = i .. tfeed[2] .. key
			feed_name = curl(pl .. tfeed[2].. key)
			feed_name = json.decode(feed_name)
			feed_name='[PL] ' .. formatfeedn(feed_name['items'][1]['snippet']['title'])
		end

		if tfeed[1] == 'favorites' then
			data = curl(c .. tfeed[2].. key)
			if string.find(data,'"totalResults": 0,') then
				data = curl(u .. tfeed[2].. key)
				feed_name = curl(cn .. tfeed[2].. key)
			else
				feed_name = curl(cnu .. tfeed[2].. key)
			end
			feed_name = json.decode(feed_name)
			feed_name='[FAV] ' .. formatfeedn(feed_name['items'][1]['snippet']['title'])
			jsondata = json.decode(data)
			uploads = jsondata['items'][1]['contentDetails']['relatedPlaylists']['likes']
			fordata = i .. uploads .. key
		end

		if tfeed[1] == 'channel' and tfeed[2] == 'mostpopular' then
			fordata = mp .. key .. region
		end
	end

	local feed_m3u_path=cfg.feeds_path..feed_name..'.m3u'
	local tmp_m3u_path=cfg.feeds_path..feed_name..'.tmp'

	local dfd=io.open(tmp_m3u_path,'w+')
	if dfd then
		if string.find(friendly_name,'youtube ') then
			plname = feed_name
		else
			plname = friendly_name
		end
		dfd:write('#EXTM3U name=\"',plname,'\" type=mp4 plugin=youtube\n')
		local i = 0
		while true do
			data = curl(fordata .. maxA .. pagetokenA)
			if data == nil or string.find(data,'"totalResults": 0,') or string.find(data,'"errors":') then
				break
			end
			jsondata = json.decode(data)
			tr = jsondata['pageInfo']['totalResults']
			if num > tr then num = tr end
			
			local vid = nil
			local title = nil
			local url = nil
			local img = nil
			
			for k,value in pairs(jsondata['items']) do
				i = i + 1
				if i > num then 
					enough = true
					break
				end
				
				if tfeed[1] == 'channel' and tfeed[2] == 'mostpopular' then
					vid = value['id']
				elseif tfeed[1] == 'search'then
					vid = value['id']['videoId']
				else
					vid = value['snippet']['resourceId']['videoId']
				end

				local title = value['snippet']['title']
				local url = 'http://www.youtube.com/watch?v=' .. vid
				local img = 'http://i.ytimg.com/vi/' .. vid .. '/mqdefault.jpg'
				dfd:write('#EXTINF:0 logo=',img,' ,',i,'. ',title,'\n',url,'\n')
			end

			if isempty(jsondata['nextPageToken'])  or enough then
				break 
			else
				nextpageA = jsondata['nextPageToken']
				pagetokenA = '&pageToken=' .. nextpageA
			end
			jsondata=nil
		end
	
		if util.md5(tmp_m3u_path)~=util.md5(feed_m3u_path) then
			if os.execute('mv \"' .. tmp_m3u_path .. '\" \"' .. feed_m3u_path .. '\"')==0 then
				rc=true
			end
		 else
			util.unlink(tmp_m3u_path)
		end
	end
	dfd:close()
	return rc
end

function youtube_sendurl(youtube_url,range)
	local url=nil
	
	if plugin_sendurl_from_cache(youtube_url,range) then 
		return
	end
		
	url=youtube_get_video_url(youtube_url)
		
	if url then

		if cfg.debug>0 then
			print('YouTube Real URL: '..url)
		end
				plugin_sendurl(youtube_url,url,range)
		else
			
		if cfg.debug>0 then 
			print('YouTube clip is not found')
		end
			
		plugin_sendfile('www/corrupted.mp4')
	end
end

function youtube_get_video_url(youtube_url)
	local id = string.match(youtube_url,'watch%?v=(.*)')
	    if cfg.youtube_fmt == 18 then
			videourl = 'http://s2h.mds-station.com:8484/play/www.youtube.com/watch?v=' .. id .. '?/?vh=360'
		    else
			videourl = 'http://s2h.mds-station.com:8484/play/www.youtube.com/watch?v=' .. id
		end
	return videourl
end


function formatfeedn( feed_name )
	feed_name = string.gsub(feed_name,'[\:*?<>|]','')
	feed_name = string.gsub(feed_name,'\"','\'')
	if string.sub(feed_name,1,7) == 'search/' then
		feed_name = string.gsub(feed_name,'/',' \'',1)
		if string.find(feed_name,'/') then
			feed_name = string.gsub(feed_name,'/','\' ',1)
		else
			feed_name = feed_name .. '\''
		end
	end
	if string.sub(feed_name,1,8) == 'channel/' then
		feed_name = string.sub(feed_name,9)
	end
	feed_name = string.gsub(feed_name,'/',' ')
	feed_name = string.gsub(feed_name,'-','_')
	return feed_name
end

plugins['youtube']={}
plugins.youtube.name="YouTube"
plugins.youtube.desc="<i>name</i> from http://www.youtube.com/user/<i>name</i> or <i>id</i> from http://www.youtube.com/channel/<i>id</i>,<br>" .. 
"favorites/<i>username</i> or favorites/<i>id</i>,<br>" .. 
"search/<i>search_string</i>/optional<i><a href=http://www.iso.org/iso/country_codes/iso_3166_code_lists/country_names_and_code_elements.htm>region</a></i>/optional<i><a href=http://www.loc.gov/standards/iso639-2/php/code_list.php>language(ISO 639-1 Code)</a></i>,<br>" .. 
"playlist/<i>id</i>,<br>" .. 
"YouTube channels: channel/mostpopular/optional<i><a href=http://www.iso.org/iso/country_codes/iso_3166_code_lists/country_names_and_code_elements.htm>region</a></i>"
plugins.youtube.sendurl=youtube_sendurl
plugins.youtube.updatefeed=youtube_updatefeed
plugins.youtube.getvideourl=youtube_get_video_url

plugins.youtube.ui_config_vars=
{
  { "select", "youtube_fmt", "int" },
  { "select", "youtube_region" },
  { "input",  "youtube_video_count", "int" }
}
