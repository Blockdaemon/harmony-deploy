#!/bin/bash
set -e
OS=$(uname -s)
mkdir -p files/bin/$OS
cd files/bin/$OS
curl -fsS -L -O https://raw.githubusercontent.com/harmony-one/go-sdk/master/scripts/hmy.sh
chmod +x hmy.sh
./hmy.sh -d
