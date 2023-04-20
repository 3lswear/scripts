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

FD="/usr/bin/fdfind"
QUERY=$@
if [[ ${0} =~ 'decim' ]]; then
	IFS=$'\n'
	QUERY='(АДЛБ|ИЦАТ) *\. *'$@
fi


main() {
    "$FD" \
		--max-depth=1 \
		--type=d \
		--hidden \
		${QUERY} \
		"/mnt/forso/cert/Документация ИЛ" \
		"/mnt/forso/cert/Материалы заявителя" \
		"/mnt/forso/certIA/Документация ИЛ" \
		"/mnt/forso/certIA/Материалы заявителя"
}

main $@
