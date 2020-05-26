#!/bin/bash

. $(dirname $0)/functions

a=accounts
if [ $# -gt 0 ]; then a=$1; fi

for i in `cat $a`; do
    "$HMY" -n https://api.s0.t.hmny.io balances $i | jq -c '{"addr": "'$i'"} + .[] | select(.amount!=0)' \
	| grep amount || echo '{"addr":"'$i'","shard":"?","amount":0"}'
done
