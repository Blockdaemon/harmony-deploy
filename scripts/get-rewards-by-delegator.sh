#!/bin/bash

TOP=$(realpath $(dirname $0)/..)
HMY=${TOP}/files/bin/hmy

a=accounts
if [ $# -gt 0 ]; then a=$1; fi

for i in `cat $a`; do
    ${HMY} -n https://api.s0.t.hmny.io blockchain delegation by-delegator $i | \
    jq -c '.result | select(length>0) |
	map ( select(.reward>0) |
	    {(.["delegator_address"]):(.reward/1e18)}
	) | select(length>0) // empty
    '
done
