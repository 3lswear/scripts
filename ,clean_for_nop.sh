#!/bin/bash
echo "DELETING EXTRA FILES NOW, CONFIRM?"
read
fdfind --type f --extension txt --extension su --extension marks --extension sh -X rm -v
fdfind --type f CHANGELOG -X rm -v
fdfind --type f README.md -X rm -v
fdfind --type empty -X rm -rfv
