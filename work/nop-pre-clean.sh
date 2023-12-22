#!/bin/bash

remove_by_signature() {
	fdfind -uu --type=f -x sh -c "file -b \"\$1\" | grep -q \"$@\" && rm -v \"\$1\"" sh "{}"
}

echo "DELETING EXTRA FILES NOW, CONFIRM?"
read

echo "> files with unprintable filenames"
LC_ALL=C find . -type f -name '*[! -~]*' -exec rm -v {} \;

echo "> symlinks:"
fdfind -uu --type=symlink -x rm -v

echo "> by extension:"
fdfind -uu --type f --extension txt --extension xml -x rm -v

echo "> text files:"
fdfind -uu --type f --glob CHANGELOG -X rm -v
fdfind -uu --type f --glob README.md -X rm -v

echo "> empty:"
fdfind -uu --type empty --type f -X rm -rfv

echo "> ascii text"
# fdfind -uu --type=f -x bash -c 'file -b "$1" | grep -q "ASCII text" && rm -v "$1"' bash "{}"
remove_by_signature "ASCII text"

echo "> very short file"
fdfind -uu --type=f -x sh -c 'file -b "$1" | grep -q "very short file (no magic)" && rm -v "$1"' sh "{}"

echo "> Bourne-Again shell scripts"
fdfind -uu --type=f -x sh -c 'file -b "$1" | grep -q "Bourne-Again shell script" && rm -v "$1"' sh "{}"

echo "> Unicode text"
fdfind -uu --type=f -x sh -c 'file -b "$1" | grep -q "Unicode text" && rm -v "$1"' sh "{}"

echo "> MS Windows shortcut"
remove_by_signature "MS Windows shortcut"
