#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [[ "${1-}" =~ ^-*h(elp)?$ || $# -eq 0 ]]; then
	echo "Usage: ./$(basename "$0") arg-one arg-two

Find project

"
    exit
fi

# FD="/usr/bin/fdfind"
FD="/usr/bin/bfs -E"
SPECIFIER="-iregex"
QUERY=".*$@.*"
if [[ ${0} =~ 'decim' ]]; then
	IFS_OLD="$IFS"
	IFS=$'\n'
	SPECIFIER="-iregex"
	QUERY=".*(АДЛБ|ИЦАТ) *\. *.*$@.*"
	IFS="$IFS_OLD"
fi


main() {
    $FD \
		-maxdepth 1 \
		-type d \
		${SPECIFIER} "${QUERY}" \
		"/mnt/forso/cert/Документация ИЛ" \
		"/mnt/forso/cert/Материалы заявителя" \
		"/mnt/forso/certIA/Документация ИЛ" \
		"/mnt/forso/certIA/Материалы заявителя"
}

main $@
