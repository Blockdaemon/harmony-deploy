#!/bin/bash
if [ ! -z "$1" ]; then
shard="$1 "
else
shard=""
fi
curl -Ss https://harmony.one/balances | sed '/.*gn-keys.*/q' | grep ^one | sort -rnk 3 | grep " $shard" | head
