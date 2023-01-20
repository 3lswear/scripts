#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

IP=$(ip -o route get 255.0 2>/dev/null | sed -e 's/.*src \([^ ]*\) .*/\1/')
MESSAGE="HIII. I'm up at $(date -R), find me @ ${IP}"
curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d text="$MESSAGE" > /dev/null 2>&1
