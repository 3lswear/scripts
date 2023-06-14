#!/bin/env python3

import os

cwd = os.getcwd()
SEARCH_BYTES = b'\xde\xad\xba\xba'
BYTES_LEN = 4

for root, dirnames, filenames in os.walk(cwd):
    for basename in filenames:
        filename = os.path.join(root, basename)
        with open(filename, "r+b") as f:
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

            if markers == []:
                continue

        print("File:", filename)
        print("size is: ", find_end)
        print("markers: ", markers)



