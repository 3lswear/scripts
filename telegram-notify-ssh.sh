#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

set -o allexport
source /etc/usersecrets/telegram.env
set +o allexport

if [ "$PAM_TYPE" = "open_session" ]; then
  MESSAGE="$PAM_USER@$PAM_RHOST: knock knock via $PAM_SERVICE at tty: $PAM_TTY"
  curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d text="$MESSAGE" > /dev/null 2>&1 &
fi
