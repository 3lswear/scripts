#!/bin/bash
if [[ $EUID -ne 0 ]]
  then echo "Please run as root"
  exit 1
fi

set -o nounset
set -e
set -x

export RESTIC_PASSWORD_FILE=/etc/restic/nextcloud.pass

restic -r /mnt/redpool/restic-repo \
	--verbose \
	--exclude='/media/wd/nextcloud/data/appdata_*' \
	backup \
	/media/wd/nextcloud/data \
	/srv/nextcloud \
	/etc/nginx/conf.d/one*


# healthcheck
curl --max-time 10 --retry 5 "$CRO_HEARTBEAT_URL"
curl --max-time 10 --retry 5 "$CRO_MONITOR_URL?state=complete"

echo "Pinged healthcheck!"
