#!/bin/bash
pushd files/bin
for i in node wallet mystatus; do
  curl -SsLO https://harmony.one/$i.sh
  chmod +x $i.sh
done
./wallet.sh -d <> /dev/null 2>&1
if dd if=wallet count=1 bs=300 | grep Error; then
   rm wallet
fi
echo asdf | ./node.sh -S -1 -k asdf > /dev/null 2>&1
chmod +x wallet harmony
if dd if=harmony count=1 bs=300 | grep Error; then
   rm harmony
fi
git -P diff harmony-checksums.txt
popd
