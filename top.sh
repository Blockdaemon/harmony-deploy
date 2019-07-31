#!/bin/bash
regex="$(tr '\n' ' ' < accounts | sed 's/ $//' | sed 's/ /\\|/g')"

for i in 0 1 2 3; do
curl -Ss https://harmony.one/balances.csv | grep ",$i," | sort -t, -rn -k3 | sed 's/^/ /' | sed 's/ \('"$regex"'\)/*\1/' | nl
done
