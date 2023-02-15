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
RM_COMMAND='rm'

TOT_SIZE=0
TOT_SAME=0
TOT_DIFFER=0

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
	echo "Usage: ./$(basename "$0")

	Удаляет копии файлов с суффиксом '-Copy(1)'.
	Удаление происходит из текущей директории.
"
    exit
fi

if [[ $(command -v fd) ]]; then
	FIND_COMMAND="fd -H --type=f --print0"
elif [[ $(command -v fdfind) ]]
then
	FIND_COMMAND="fdfind -H --type=f --print0"
else 
	FIND_COMMAND="find . -type f -print0"
fi

# FIND_COMMAND="find . -type f -print0"

printf "${GREEN}"
echo "[i] Using command: $FIND_COMMAND"
printf "${RST}"


if [[ "${1-}" =~ ^-*n$ ]]; then
	# DRY_RUN=1
	RM_COMMAND='echo # rm'
	printf "${GREEN}"
	printf '===========================\n'
	echo -e "[i] Dry run mode! No files are deleted!"
	printf '===========================\n'
	printf "${RST}"
fi

while IFS= read -r -d '' file; do 
	echo '>' "$file"
	file_copy="${file%.*}-Copy(1).${file##*.}"
	if test -f "$file_copy"; then
		fsize=$(stat --format='%s' "$file")
		printf "${GREEN}[+] has a copy, size is %'d K${RST}\n" $((fsize/1024))
		if diff -q "$file" "$file_copy"; then
			((TOT_SAME++))
			((TOT_SIZE=TOT_SIZE+"$fsize"))
			echo -e "${GREEN}[+] files are identical"
			${RM_COMMAND} -v -- "$file_copy";
			echo -e "$RST"
		else
			((TOT_DIFFER++))
			echo -e "${RED}[X] files differ${RST}"
		fi
	
	fi
done < <($FIND_COMMAND)

	printf "${GREEN}"
	printf "[i] STATS:\n"
	printf "Space freed:\n%'d K, or %'d M\n" $((TOT_SIZE/1024)) $((TOT_SIZE/1024/1024))
	printf "Identical files: %'d\nAltered files: %'d\n" "$TOT_SAME" "$TOT_DIFFER"
	printf "${RST}"
