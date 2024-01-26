#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
	echo "Usage: ./$(basename "$0") arg-one arg-two

Reencode with ffmpeg to save space. DELETES original file!

"
    exit
fi

main() {
	ORIG_NAME="$1"
	NEW_NAME=new_$(basename "$ORIG_NAME")
	CRF=18
	OPTION=(-preset 9)
	CODEC=libsvtav1
	ffmpeg -i "$ORIG_NAME" -c:v $CODEC \
		"${OPTION[@]}" \
		-crf $CRF \
		-map_metadata 0 -movflags use_metadata_tags \
		"$NEW_NAME"
		# out_${CODEC}_crf${CRF}_pres${OPTION[2]}.mp4 \
	touch -am --reference="$ORIG_NAME" "$NEW_NAME"
	echo Processed "$NEW_NAME"
	# mv -v "$NEW_NAME" "$ORIG_NAME"
	# rm -rfv "$ORIG_NAME"
}

main "$@"
