#!/bin/bash
pushd files/bin
for i in node wallet mystatus; do
  curl -SsLO https://harmony.one/$i.sh
  chmod +x $i.sh
done
./wallet.sh -d
echo asdf | ./node.sh -S -1 -k asdf <> /dev/null 2>&1
git -P diff harmony-checksums.txt
popd
