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

cd "$(dirname "$0")"

main() {
	sudo -v
	KEYVALS=$(sudo cat /etc/wireguard/wg0.conf | awk '/^# BEGIN_PEER/ {print $3}; /^PublicKey =/ {print $3}')
	tmp="";

	WG_COLOR_MODE=always
	local output=$(WG_COLOR_MODE=always sudo -E wg show);
	declare -A peers;
	local i=0;
	for line in $KEYVALS; do
		if [[ $((i % 2)) == 0 ]]; then
			tmp="$line"
		else
			peers["$tmp"]="$line";
		fi
		i=$((i + 1))
	done;

	for key in ${!peers[@]}
	do
		# echo "${key}, ${peers[${key}]}"
		output=$(printf "%s\n" "$output" | sed "s|${peers[${key}]}|[${key}] ${peers[${key}]}|")
	
	done
	
	printf "%s\n" "$output"
}

main "$@"
