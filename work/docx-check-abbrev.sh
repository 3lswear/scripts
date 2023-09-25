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

print_sep() {

awk 'BEGIN{
    s="------------------------------>";;
    for (colnum = 0; colnum<77; colnum++) {
        r = 255-(colnum*255/76);
        g = (colnum*510/76);
        b = (colnum*255/76);
        if (g>255) g = 510-g;
        printf "\033[48;2;%d;%d;%dm", r,g,b;
        printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
        printf "%s\033[0m", substr(s,colnum+1,1);
    }
}'

}


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
		echo " [$word]:"
		rg -C2 "\b$word\b" "$TEXTFILE" ;
		print_sep
	done

	echo -e "\n[i] SUMMARY:\n"

	for word in $ABBREV ;
	do
		echo -n $word ""; rg --count-matches "\b$word\b" "$TEXTFILE" || echo -- ;
	done

	rm "$TEXTFILE"
}

main "$@"
