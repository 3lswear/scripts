#!/usr/bin/env bash

grep -ar --include '*.lib' --include '*.obj' --include '*.pch' \
	$'\xba\xba\xad\xde\x01\x02\x04\x80' --only-matching --byte-offset | \
	tee | #optional \
	cut -d':' -f 1,2 | \
	sed "s/^/'/;s/:/' /" | \
	xargs -L 1 bash -xc 'printf "ZZZZZZZZ" | dd of="$0" bs=1 seek="$1" conv=notrunc'
