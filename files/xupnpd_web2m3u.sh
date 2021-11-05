#!/opt/bin/bash
SOURCEFILE='[PL] Raznoe.m3u'
SOURCEPATH="/opt/share/xupnpd/playlists/"
FULLSOURCEPATH="/opt/share/xupnpd/playlists/[PL] Raznoe.m3u"
FULLSOURCEPATH2="/opt/tmp/ytrtmp.m3u"
FINALPATH="/opt/share/xupnpd/www/"
FINALM3U="ytr.m3u"

cp "${FULLSOURCEPATH}" ${FULLSOURCEPATH2}

sed -i 's/plugin=youtube//g' "${FULLSOURCEPATH2}"
sed -i 's/http:\/\/www./http:\/\/s2h.mds-station.com:8484\/play\/www./g' "${FULLSOURCEPATH2}"
sed -i '/^http:\/\/s2h/ s|$|?/?vh=360|' "${FULLSOURCEPATH2}"

mv "${FULLSOURCEPATH2}" $FINALPATH/$FINALM3U

exit 0
