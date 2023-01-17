#!/usr/bin/env bash


# set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

# shopt -s globstar
# shopt -s dotglob
# set -e
RED="\e[31m"
GREEN="\e[32m"
RST="\e[0m"

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
	echo "Usage: ./$(basename "$0")

	Удаляет копии файлов с суффиксом '-Copy(1)'.
	Удаление происходит из текущей директории.

"
    exit
fi

find . -type f -print0 | 
    while IFS= read -r -d '' file; do 
        echo '>' "$file"
		file_copy="${file%.*}-Copy(1).${file##*.}"
		if test -f "$file_copy"; then
			echo -e "${GREEN}[+] has a copy${RST}";
			# SUM1=$(md5sum "$file") | cut -d' ' -f 1
			# SUM2=$(md5sum "$file_copy") | cut -d' ' -f 1
			# if [[ "$SUM1" == "$SUM2" ]]; then
			if diff -q "$file" "$file_copy"; then
				echo -e "${GREEN}[+] files are identical"
				rm -v -- "$file_copy";
				echo -e "$RST"
			else
				echo -e "${RED}[X] files differ${RST}"
			fi
		
		fi
    done
