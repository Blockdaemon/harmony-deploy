#!/bin/bash

if [ $# -gt 0 -a -r "$1" ]; then
    sed=()
    for i in `cat $1`; do
	n=$(hmy -n https://api.s0.t.hmny.io blockchain validator information $i | jq .result.validator.name)
	sed+=("s/$i/$n/")
    done
    grep=$(tr '\n' ' ' < $1 | sed 's/ $//' | sed 's/ /\\|/g')
fi
if [ "${#sed[@]}" -gt 0 ]; then
    sed=$( IFS=\; ; echo "${sed[*]}")
fi

hmy -n https://api.s0.t.hmny.io blockchain median-stake | jq -cr -f auction.js | grep "$grep" | sed -e "$sed"
