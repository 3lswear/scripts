#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [[ "${1-}" =~ ^-*h(elp)?$ || $# -eq 0 ]]; then
	echo "Usage: ./$(basename "$0") arg-one arg-two

	 Copy BTRFS subvolume with send/receive.

"
    exit
fi

# cd "$(dirname "$0")"

main() {

	SUBVOL="$1"
	DEST="$2"

	# echo "$PWD"
	sudo btrfs property set "$SUBVOL" ro true
	sudo btrfs send "$SUBVOL" | mbuffer | sudo btrfs receive "$DEST"

	sudo btrfs property set "$SUBVOL" ro false

}

main "$@"
