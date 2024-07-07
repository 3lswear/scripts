#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
	echo "Usage: ./$(basename "$0") -p PRESET -v VMAF FILE

Reencode with ab-av1 to save space.

"
    exit
fi

main() {
	while getopts ":p:v:" opt; do
		case $opt in
			p)
				PRESET="$OPTARG"
				;;
			v)
				MINVMAF="$OPTARG"
				;;
			\?)
				echo "Invalid option: -$OPTARG" >&2
				;;
		esac
	done
		shift $((OPTIND-1))

	IN="$*"
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

	# RUST_LOG=ab_av1=info ~/.cargo/bin/ab-av1 auto-encode \
	~/.cargo/bin/ab-av1 auto-encode \
		--preset "$PRESET" \
		--min-vmaf "$MINVMAF" \
		-i "$IN" \
		-o "$DIR/$TMP_BASE" && \
		mv "$DIR/$TMP_BASE" "$OUT"
	exiftool -P -overwrite_original_in_place -EncodedBy="reenc2av1_1" "$OUT"
	touch -am --reference="$IN" "$OUT"
	echo Processed "$OUT"
}

main "$@"
