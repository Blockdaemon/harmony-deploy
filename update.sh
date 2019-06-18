#!/bin/bash
cd files/bin
curl -LO https://harmony.one/node.sh
echo asdf | fakeroot ./node.sh -1 asdf > /dev/null 2>&1
git diff harmony-checksums.txt
