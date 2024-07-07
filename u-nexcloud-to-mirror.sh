#!/bin/bash
if [[ $EUID -ne 0 ]]
  then echo "Please run as root"
  exit 1
fi

set -o nounset
set -e
set -x

export RESTIC_PASSWORD_FILE=/etc/restic/nextcloud.pass
export RESTIC_COMPRESSION=max

restic -r /media/compraid/restic-repo \
	--verbose \
	--exclude='/media/black/nextcloud/data/appdata_*' \
	--exclude='/srv/nextcloud/volumes/appdata_*' \
	backup \
	/media/black/nextcloud/data \
	/srv/nextcloud \
	/etc/nginx/conf.d/one*


# healthcheck
curl --max-time 10 --retry 5 "$CRO_HEARTBEAT_URL"
curl --max-time 10 --retry 5 "$CRO_MONITOR_URL?state=complete"

echo "Pinged healthcheck!"
