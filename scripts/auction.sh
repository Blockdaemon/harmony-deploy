#!/bin/bash

. $(dirname $0)/functions

if [ $# -gt 0 -a -r "$1" ]; then
    sed=()
    for i in `cat $1`; do
	n=$(${HMY} -n https://api.s0.t.hmny.io blockchain validator information $i | jq -r .result.validator.name)
	sed+=("s/$i/$n/")
    done
    grep=$(tr '\n' ' ' < $1 | sed 's/ $//' | sed 's/ /\\|/g')
fi
if [ "${#sed[@]}" -gt 0 ]; then
    sed=$( IFS=\; ; echo "${sed[*]}")
fi

${HMY} -n https://api.s0.t.hmny.io blockchain median-stake | \
    jq -cr '
	[ .result["epos-slot-candidates"][] |
	    {"s": .["stake-per-key"], "v": .validator, "k": .["keys-at-auction"][]}
	] |
	sort_by(.s) | reverse |
	to_entries | map([(.key + 1), .value.v, (.value.s/1e+18)]) | .[]
    ' | \
    grep "$grep" | sed -e "$sed"
