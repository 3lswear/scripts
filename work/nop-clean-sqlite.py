#!/bin/env python3

import sqlite3
import os

def query_wildcard(cur, str):
    res = cur.execute(f"select filename from files where file_type like '%{str}%'")
    # print(res.fetchall())
    return (res)

def remove_wildcard(cur, str):
    for row in query_wildcard(cur, str):
        print(row[0])
        try:
            os.remove(row[0])
        except FileNotFoundError:
            print(f"warning, file {row[0]} not found")




con = sqlite3.connect(':memory:')
cur = con.cursor()
cur.execute('''CREATE TABLE IF NOT EXISTS files (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    filename TEXT,
    extension TEXT,
    file_type TEXT
    );
            ''')

for root, _, basenames in os.walk(os.getcwd()):
    for basename in basenames:
        filepath = os.path.join(root, basename)
        # print(filepath)
        extension = basename.split('.')[-1]
        file_type = os.popen(f"file -b {filepath}").read()
        con.execute(f'''INSERT INTO files (filename, extension, file_type) VALUES \
                     ('{filepath}', '{extension}', '{file_type}')''')
        # print('.', end='', flush=True)
    # print(root)

print()
con.commit()

remove_wildcard(con, "C++")
remove_wildcard(con, "ASCII text")
remove_wildcard(con, "very short file (no magic)")
remove_wildcard(con, "Bourne-Again shell script")
remove_wildcard(con, "Unicode text")
remove_wildcard(con, "MS Windows shortcut")
remove_wildcard(con, "empty")

