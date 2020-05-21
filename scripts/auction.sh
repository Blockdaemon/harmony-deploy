#!/bin/bash
hmy -n https://api.s0.t.hmny.io blockchain median-stake | jq -cr '[.result["epos-slot-candidates"][] | {"s": .["stake-per-key"], "v": .validator, "k": .["keys-at-auction"][]}] | sort_by(.s) | reverse | to_entries | map([(.key + 1), .value.v]) | .[]'
