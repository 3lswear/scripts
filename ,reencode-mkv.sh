#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
	echo "Usage: ./$(basename "$0") arg-one arg-two

This is an awesome bash script to make your life better.

"
    exit
fi

main() {
	ORIG_NAME="$1"
	NEW_NAME="${ORIG_NAME/%mkv/mp4}"
	ffmpeg -i "$ORIG_NAME" -vcodec copy -acodec copy -map_metadata 0 "$NEW_NAME"
	touch -am --reference="$ORIG_NAME" "$NEW_NAME"
	echo Processed "$NEW_NAME"
}

main "$@"
