#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [[ "${1-}" =~ ^-*h(elp)?$ || $# -eq 0 ]]; then
	echo "Usage: ./$(basename "$0") arg-one arg-two

This is an awesome bash script to make your life better.

"
    exit
fi

main() {
	FILE="$@"
	TEXTFILE=$(mktemp)
	java -jar ~/winhome/_software/tika-app-2.8.0.jar --text "$FILE" > "$TEXTFILE"

	ABBREV=$(rg -i --multiline-dotall --multiline 'перечень\s+сокращений.*?(1.)*объект\s+испытаний' "$TEXTFILE" | \
		rg --multiline --multiline-dotall --only-matching '\s+[А-Я]{2,7}(\s[А-Я]{2,7})*$' | \
		awk '{$1=$1;print}')


	IFS=$'\n'
	echo "[i] checking..."
	for word in $ABBREV ;
	do
		echo -n $word ""; rg --count-matches "\b$word\b" "$TEXTFILE" || echo -- ;
	done

	rm "$TEXTFILE"
}

main "$@"
