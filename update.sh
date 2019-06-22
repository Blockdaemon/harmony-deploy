#!/bin/bash
pushd files/bin
for i in node wallet mystatus; do
  curl -LO https://harmony.one/$i.sh
  chmod +x $i.sh
done
./wallet.sh -d
echo asdf | fakeroot ./node.sh -1 -k asdf <> /dev/null 2>&1
git diff harmony-checksums.txt
popd
