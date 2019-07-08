#!/bin/bash
regex="$(tr '\n' ' ' < accounts | sed 's/ $//' | sed 's/ /\\|/g')"

for i in 0 1; do
curl -Ss https://harmony.one/balances | cut -f 2 -d \' | sed '/.*gn-keys.*/q' | grep ^one | grep "[a-z0-9] $i " | sort -rnk 4 | sed 's/^/ /' | sed 's/ \('"$regex"'\)/*\1/' | nl
done
