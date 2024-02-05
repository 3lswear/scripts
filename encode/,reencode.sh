#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
	echo "Usage: ./$(basename "$0") file-to-encode

Reencode with ffmpeg to save space. DELETES original file!

"
    exit
fi

main() {
	IN="$1"
	OUT=$(basename -- "$IN")
	EXT="${OUT##*.}"
	OUT="${OUT%.*}_conv.$EXT"
	CRF=18
	OPTION=(-preset 9)
	CODEC=libsvtav1
	ffmpeg -i "$IN" -c:v $CODEC \
		"${OPTION[@]}" \
		-crf $CRF \
		-g 240 -svtav1-params tune=0:enable-overlays=1:scd=1:scm=0:film-grain=8 -pix_fmt yuv420p10le \
		-map_metadata 0 -movflags use_metadata_tags \
		"$OUT"
		# out_${CODEC}_crf${CRF}_pres${OPTION[2]}.mp4 \
	exiftool -EncodedBy="reenc2av1_1" "$OUT"
	touch -am --reference="$IN" "$OUT"
	echo Processed "$OUT"
	printf "Processed file $OUT at $(date -Is), took %s time\n"
	# mv -v "$OUT" "$IN"
	# rm -rfv "$IN"
}

main "$@"
