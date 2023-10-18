#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [[ "${1-}" =~ ^-*h(elp)?$ || $# -eq 0 ]]; then
	echo "Usage: ./$(basename "$0") arg-one arg-two

	Transcribe and add subtitles to video

"
    exit
fi

main() {
	T_LANG="${T_LANG:-ru}"
	if [[ "$T_LANG" == "ru" ]]; then
		PROMPT="Привет."
	elif [[ "$T_LANG" == "en" ]]; then
		PROMPT="Hello."
	fi

	TMPDIR=$(mktemp -d)
	echo "TMPDIR is $TMPDIR"
	echo "T_LANG is [$T_LANG], PROMPT is [$PROMPT]"
	IN_FILE="$1"
	OUT_FILE=new_$(basename "$IN_FILE")
	AUDIO=audio_$(basename "$IN_FILE").wav
	ffmpeg -i "$IN_FILE" -vn -ar 16000 -ac 1 -c:a pcm_s16le "$TMPDIR/$AUDIO"
	SUB_FILE="${AUDIO/%\.wav/\.srt}"
	whisper-ctranslate2 --model large-v2 \
		--initial_prompt "$PROMPT" \
		--vad_filter True \
		--print_colors True \
		--output_format srt \
		--output_dir "$TMPDIR" \
		"$TMPDIR/$AUDIO"
	ffmpeg -i "$IN_FILE" -i "$TMPDIR/$SUB_FILE" \
		-map 0 \
		-map -0:s \
		-map 1 \
		-c:v copy -c:a copy -c:s mov_text \
		"$TMPDIR/$OUT_FILE"
	touch -am --reference="$IN_FILE" "$TMPDIR/$OUT_FILE"
	mv -v "$TMPDIR/$OUT_FILE" "$IN_FILE"
	rm -rfv "$TMPDIR"
}

main "$@"
