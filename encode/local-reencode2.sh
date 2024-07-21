#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
	echo "Usage: ./$(basename "$0") [-A | -E] -p PRESET [-v VMAF | -c CRF] FILE

Reencode with ab-av1 to save space.

"
    exit
fi

main() {

	OPTIONS=("$@")
	while [[ "$1" != "-i" ]]; do
		shift
	done

	while getopts ":i:" opt; do
		case $opt in
			i)
				IN="$OPTARG"
				;;
			\?)
				echo "Invalid option: -$OPTARG" >&2
				;;
		esac
	done

	if [[ $IN == "" ]]; then
		echo "Invalid file name"
		exit 1
	fi
	IN_BASE=$(basename -- "$IN")
	DIR=$(dirname -- "$IN")
	EXT="${IN_BASE##*.}"
	OUT_BASE="${IN_BASE%.*}.av1.$EXT"
	OUT="$DIR/$OUT_BASE"
	if [[ -f "$OUT" ]]; then
		echo "$OUT" Already exists! Exiting.
		exit
	fi
	TMP_BASE="${IN_BASE%.*}.TMP.$EXT"

	renice -n 15 -p $$
	# RUST_LOG=ab_av1=info ~/.cargo/bin/ab-av1 "$MODE" \
	ab-av1 "${OPTIONS[@]}" \
		-o "$DIR/$TMP_BASE" && \
		mv "$DIR/$TMP_BASE" "$OUT"
	exiftool -P -overwrite_original_in_place -EncodedBy="reenc2av1_1" "$OUT"
	touch -am --reference="$IN" "$OUT"
	echo Processed "$OUT"
}

main "$@"
