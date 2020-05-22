#!/bin/bash

if [ $# -gt 0 -a -r "$1" ]; then
    regex=$(tr '\n' ' ' < $1 | sed 's/ $//' | sed 's/ /\\|/g')
fi

hmy -n https://api.s0.t.hmny.io blockchain median-stake | jq -cr -f auction.js | grep "$regex"
