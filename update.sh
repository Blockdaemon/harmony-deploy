#!/bin/bash
pushd files/bin
curl -LO https://harmony.one/node.sh
chmod +x node.sh
echo asdf | fakeroot ./node.sh -1 -k asdf <> /dev/null 2>&1
git diff harmony-checksums.txt
popd
