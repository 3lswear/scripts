#!/bin/env python3

import os, sys

SEARCH_BYTES = b'\xde\xad\xba\xba'
BYTES_LEN = 4

def process_file(filepath):
    with open(filepath, "r+b") as f:
        buffer = f.read()

        markers = []

        find_start = int(0)
        find_end = len(buffer)
        while (True):
            offset = buffer.find(SEARCH_BYTES, find_start, find_end)
            if (offset == -1):
                break
            find_start = offset + BYTES_LEN

            marker_bytes = buffer[offset + 4:offset + 8]
            marker_num = int.from_bytes(marker_bytes, 'big', signed=False)
            markers.append((offset, marker_num))

            # flip and write
            f.seek(offset)
            f.write(SEARCH_BYTES[::-1])
            f.seek(offset + BYTES_LEN)
            f.write(marker_bytes[::-1])

        # if markers == []:
        #     return

        print("File:", filepath, file=sys.stderr)
        print("size, b: ", find_end, file=sys.stderr)
        print("markers: ", markers, file=sys.stderr)

        return

def process_dir(path):
    for root, dirs, basenames in os.walk(path):
        for basename in basenames:
            filepath = os.path.join(root, basename)
            process_file(filepath)

def print_err():
    print("Error: invalid arguments. Valid: '.', <file>", file=sys.stderr)

if __name__ == "__main__":
    if len(sys.argv) == 2 \
        and not ((sys.argv[1] == "-h") or (sys.argv[1] == "--help")):
        if sys.argv[1] == '.':
            process_dir(os.getcwd())
        else:
            process_file(sys.argv[1])
    else:
        print_err()
