#!/bin/bash
echo "DELETING EXTRA FILES NOW, CONFIRM?"
read
echo "> by extension:"
fdfind --type f --extension txt --extension xml -X rm -v
echo "> text files:"
fdfind --type f --glob CHANGELOG -X rm -v
fdfind --type f --glob README.md -X rm -v
echo "> empty:"
fdfind --type empty --type f -X rm -rfv

echo "> ascii text"
fdfind --type=f -x file {} | grep -F ': ASCII text, with no line terminators' | cut -d':' -f 1 | xargs -n1 rm -v

echo "> just ascii text"
fdfind --type=f -x file {} | grep ': ASCII text$' | cut -d':' -f 1 | xargs -n1 rm -v

echo "> very short file"
fdfind --type=f -x file {} | grep ': very short file (no magic)$' | cut -d':' -f 1 | xargs -n1 rm -v

echo "> Bourne-Again shell scripts"
fdfind --type=f -x file {} | grep -F ': Bourne-Again shell script' | cut -d':' -f 1 | xargs -n1 rm -v
