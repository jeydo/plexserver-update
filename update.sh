DATE=`date +%Y%m%d%S`
BUILD="linux-x86_64"
DISTRO="debian"
JSON_FILE="plex.json"
DEB_FILE="plexmediaserver.deb"
curl https://plex.tv/api/downloads/5.json?=_$DATE > $JSON_FILE

JSON=`jq -r -c '.computer.Linux.releases[]' $JSON_FILE`

while read item; do
	if [ `echo $item | jq -r '.build'` = "$BUILD" ] && [ `echo $item | jq -r '.distro'` = "$DISTRO" ]; then
		wget $(echo $item | jq -r '.url') -O $DEB_FILE
		sudo dpkg -i $DEB_FILE
	fi
done <<< "$JSON"

