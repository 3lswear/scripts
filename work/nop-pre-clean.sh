#!/bin/bash
echo "DELETING EXTRA FILES NOW, CONFIRM?"
read
echo "> by extension:"
fdfind -uu --type f --extension txt --extension xml -X rm -v
echo "> text files:"
fdfind -uu --type f --glob CHANGELOG -X rm -v
fdfind -uu --type f --glob README.md -X rm -v
echo "> empty:"
fdfind -uu --type empty --type f -X rm -rfv

echo "> ascii text"
# fdfind -uu --type=f -x file "{}" | grep -F ': ASCII text, with no line terminators' | cut -d':' -f 1 | sed "s/^/'/;s/$/'/" | xargs -n1 rm -v
fdfind -uu --type=f -x bash -c 'file -b "$1" | grep -q "ASCII text" && rm -v "$1"' bash "{}"

# echo "> just ascii text"
# fdfind -uu --type=f -x file "{}"| grep ': ASCII text$' | cut -d':' -f 1 | sed "s/^/'/;s/$/'/" | xargs -n1 rm -v

echo "> very short file"
fdfind -uu --type=f -x bash -c 'file -b "$1" | grep -q "very short file (no magic)" && rm -v "$1"' bash "{}"

echo "> Bourne-Again shell scripts"
fdfind -uu --type=f -x bash -c 'file -b "$1" | grep -q "Bourne-Again shell script" && rm -v "$1"' bash "{}"

echo "> Unicode text"
fdfind -uu --type=f -x bash -c 'file -b "$1" | grep -q "Unicode text" && rm -v "$1"' bash "{}"
