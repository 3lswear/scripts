#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
	echo "Usage: ./$(basename "$0") arg-one arg-two

This is an awesome bash script to make your life better.

"
    exit
fi
# if [[ $(command -v fd) ]]; then
# 	FIND_COMMAND="fd -H --type=f --print0"
# elif [[ $(command -v fdfind) ]]
# then
# 	FIND_COMMAND="fdfind -H --type=f --print0"
# else 
# 	FIND_COMMAND="find . -type f -print0"
# fi

# FIND_COMMAND="find . -type f -print0"
FIND_COMMAND="fdfind -H --type=f --print0"
DBFILE=$(mktemp).db

query_wildcard() {
	sqlite3 "$DBFILE" "select filename from files where file_type like '%$*%'"
}

query_delete() {
	printf "> DELETING [%s]\n" "$@"
	while IFS= read -r line; do
		rm -v "$line"
	done < <(query_wildcard "$@")
}

loop_body() {
	file="$*"
	local file_type=$(file -b "$file")
	local extension=$(echo "${file##*/}" | grep -F '.' | awk -F'.' '{print $NF}')
	# printf ">> %s %s %s \n" "$file" "$extension" "$file_type"
	printf '.'
	sqlite3 "$DBFILE" "INSERT INTO files (filename, extension, file_type) VALUES \
		('$file','$extension','$file_type')"
}

export -f loop_body

main() {
	# DBFILE=/tmp/tmp.p2ttBpwYJY.db

	sqlite3 "$DBFILE" <<EOF
PRAGMA journal_mode = wal2;
CREATE TABLE IF NOT EXISTS files (
id INTEGER PRIMARY KEY AUTOINCREMENT,
filename TEXT,
extension TEXT,
file_type TEXT
);
EOF

while IFS= read -r -d '' file; do
	# parallel loop_body ::: "$file"
	loop_body "$file"
done < <($FIND_COMMAND)


	echo "$DBFILE"
#
# query_wildcard "C++"
query_delete "ASCII text"
query_delete "very short file (no magic)"
query_delete "Bourne-Again shell script"
query_delete "Unicode text"
query_delete "MS Windows shortcut"
query_delete "empty"
}





main "$@"
