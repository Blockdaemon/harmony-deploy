#!/bin/bash
set -e
OS=$(uname -s)
mkdir -p files/bin/$OS
cd files/bin/$OS
curl -sS -O https://raw.githubusercontent.com/harmony-one/go-sdk/master/scripts/hmy.sh
chmod u+x hmy.sh
./hmy.sh -d
