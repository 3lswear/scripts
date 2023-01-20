#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [[ $EUID -ne 0 ]]
  then echo "Please run as root"
  exit 1
fi

export RESTIC_PASSWORD_FILE=/etc/usersecrets/restic-user.pass
restic -r /mnt/redpool/restic-root/ \
	backup -x --exclude /home/roman/.bup --exclude-file /home/roman/excludefile.txt \
	/home/roman /etc -v
