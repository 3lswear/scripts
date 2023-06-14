#!/bin/env python3

import os

SEARCH_BYTES = b'\xde\xad\xba\xba'
BYTES_LEN = 4

for root, dirs, basenames in os.walk(os.getcwd()):
    for basename in basenames:
        filepath = os.path.join(root, basename)
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

            if markers == []:
                continue

        print("File:", filepath)
        print("size: ", find_end)
        print("markers: ", markers)



