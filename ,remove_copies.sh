#!/bin/bash


# shopt -s globstar
# shopt -s dotglob
# set -e

find . -type f -print0 | 
    while IFS= read -r -d '' file; do 
        echo ++ "$file" ++
		file_copy="${file%.*}-Copy(1).${file##*.}"
		if test -f "$file_copy"; then
			echo "HAS A COPY";
			# SUM1=$(md5sum "$file") | cut -d' ' -f 1
			# SUM2=$(md5sum "$file_copy") | cut -d' ' -f 1
			# if [[ "$SUM1" == "$SUM2" ]]; then
			if diff "$file" "$file_copy"; then
				echo "FILES ARE THE SAME"
				rm -v -- "$file_copy";
			else
				echo "FILES DIFFER"
			fi
		
		fi
    done
