#!/bin/bash

. $(dirname $0)/functions

a=accounts
if [ $# -gt 0 ]; then a=$1; fi

for i in `cat $a`; do
    ${HMY} -n https://api.s0.t.hmny.io blockchain validator information $i | \
    jq '.result.validator |
    { (.address): .delegations |
	map( select(.reward>0) |
	    {(.["delegator-address"]):(.reward/1e18)}
	) | add
    } | del(.[]|nulls) | select(length>0)
    '
done
