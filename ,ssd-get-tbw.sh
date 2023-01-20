#!/bin/bash
# amount of 65536 sector writes
INPUT=$(sudo smartctl --all /dev/sda --json | \
	jq '.ata_smart_attributes.table[] | select(.id | contains(225)).raw.value')
# echo $INPUT
BYTES=$(echo "$INPUT" '*' 65536 '*' 512 | bc)
GB=$(echo 'scale=2;' "$BYTES" / '(1024^3)' | bc)
TB=$(bc <<< "scale=2; $GB/1024")
echo $GB GB
echo "$TB" TB
echo written



