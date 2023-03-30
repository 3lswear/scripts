#!/bin/bash

while ! ping -c 1 -n -w 3 "$1" > /dev/null
do
	echo -n '.'
done
wsl-notify-send.exe "$1 ONLINE!"
