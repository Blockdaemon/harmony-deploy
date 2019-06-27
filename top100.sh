#!/bin/bash
regex="$(tr '\n' ' ' < accounts | sed 's/ $//' | sed 's/ /\\|/g')"
curl -Ss https://harmony.one/balances | cut -f 2 -d \' | sed '/.*gn-keys.*/q' | grep ^one | sort -rnk 4 | sed 's/^/ /' | sed 's/ \('"$regex"'\)/*\1/' | nl | head -100
