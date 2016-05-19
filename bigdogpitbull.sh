#!/bin/sh
read -p "How many recent videos do you wish to download? " qty
if [ "$qty" -gt 0 ]; then
	./.giant_bomb_cli.py -l $qty --quality hd --download
else
	echo "Oh, okay. Aborting."
fi
