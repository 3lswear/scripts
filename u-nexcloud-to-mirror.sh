#!/bin/bash
if [[ $EUID -ne 0 ]]
  then echo "Please run as root"
  exit 1
fi

set -e
set -x

export RESTIC_PASSWORD_FILE=/etc/restic/nextcloud.pass

restic -r /media/compraid/restic-repo \
	--verbose \
	backup \
	/srv/nextcloud

restic -r /media/compraid/restic-repo \
	--verbose \
	--exclude='/media/wd/nextcloud/data/appdata_*' \
	backup \
	/media/wd/nextcloud/data

# healthcheck
curl -m 10 --retry 5 "$HC_URL"

echo "Pinged healthcheck!"
