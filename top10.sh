#!/bin/bash
if [ ! -z "$1" ]; then
shard="$1 "
else
shard=""
fi
curl -Ss `curl -Ss https://harmony.one/balances | cut -f 2 -d \'` | sed '/.*gn-keys.*/q' | grep ^one | sort -rnk 4 | grep " $shard" | head
