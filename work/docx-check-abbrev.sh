#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [[ "${1-}" =~ ^-*h(elp)?$ || $# -eq 0 ]]; then
	echo "Usage: ./$(basename "$0") документ.docx

Проверяет документ на наличие ненужных сокращений из перечня.
"
    exit
fi

TIKA_PATH="$HOME/.local/share/tika-app.jar"

check_deps() {
	status=0
	hash java 2>/dev/null || { echo >&2 "[Error] java не установлен"; status=1; }
	hash rg 2>/dev/null || { echo >&2 "[Error] ripgrep не установлен"; status=1; }
	hash awk 2>/dev/null || { echo >&2 "[Error] awk не установлен"; status=1; }
	hash sed 2>/dev/null || { echo >&2 "[Error] sed не установлен"; status=1; }
	[ -f "$TIKA_PATH" ] || { echo >&2 "[Error] apache tika не установлен.
Скачать: \`wget https://dlcdn.apache.org/tika/2.9.1/tika-app-2.9.1.jar -O \$HOME/.local/share/tika-app.jar\` 
или поменять \$TIKA_PATH файлу в скрипте
	"; status=1; }
	if [[ $status == 1 ]]; then 
		exit 1;
	fi
}


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

	check_deps

	FILE="$*"
	TEXTFILE=$(mktemp)
	java -jar "$TIKA_PATH" --text "$FILE" > "$TEXTFILE"

	ABBREV=$(rg -i --multiline-dotall --multiline 'перечень\s+сокращений\s*$.*объект\s+испытаний'  "$TEXTFILE" | \
		sed 's/перечень\s\+сокращений//i; s/объект\s\+испытаний//i' | \
		rg --multiline --multiline-dotall --only-matching '\s*[А-Я]{2,7}(\s+[А-Я]{2,7})*\s*$' | \
		awk '{$1=$1;print}')


	IFS=$'\n'
	echo "[i] checking..."
	for word in $ABBREV ;
	do
		print_sep
		echo " [$word]:"
		rg -C2 "\b$word\b" "$TEXTFILE" ;
	done

	echo -e "\n[i] SUMMARY:\n"

	for word in $ABBREV ;
	do
		printf "%-15s\033[10G %s\n" "$word" "$(rg --count-matches "\b$word\b" "$TEXTFILE" || echo --)";
	done

	rm "$TEXTFILE"
}

main "$@"
