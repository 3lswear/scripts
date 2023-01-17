#!/bin/sh
echo "DELETING EXTRA FILES NOW, CONFIRM?"
read
fd --type f --extension txt --extension su --extension marks -X rm -v 
fd --type f CHANGELOG -X rm -v
fd --type f README.md -X rm -v
