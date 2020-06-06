#!/bin/bash

. $(dirname $0)/functions

a=accounts
if [ $# -gt 0 ]; then a=$1; fi

for i in `cat $a`; do
    ${HMY} -n https://api.s0.t.hmny.io blockchain delegation by-delegator $i | \
    jq -c '.result | select(length>0) |
	map ( select(.amount>0) | {
		(.["delegator_address"]): {(.["validator_address"]):(.amount/1e18)}
	    }
	) | select(length>0) // empty
    '
done
