#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
#
## Extract the video from a MotionPhoto file to PXL_*.MP.mp4
#
# Find out where in the file the video part starts
position=$(grep --binary --byte-offset --only-matching --text ftypisom "$1" |
		cut --delimiter=':' --fields=1)
position=$(echo "$position - 4" | bc)
# grep --binary --byte-offset --only-matching --text ftypiso "$1"
dd if="$1" skip=1 bs=$position of="$(basename -s .jpg $1).mp4"
