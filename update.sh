#!/usr/bin/env bash

# Force OS download to Linux
OS=Linux

pushd files/bin
echo "getting wrappers"
for i in node.sh tui; do
  curl -SsLO https://harmony.one/$i
  chmod +x $i
done

for i in go-sdk/master/scripts/hmy.sh harmony-ops/master/monitoring/mystatus.sh; do
    curl -SsLO https://raw.githubusercontent.com/harmony-one/$i
    chmod +x $(basename $i)
done

echo "updating hmy"
sed -e "s/curl /curl -sS /;s/uname -s/echo $OS/" hmy.sh > hmy-linux.sh
bash ./hmy-linux.sh -d
if dd if=hmy count=1 bs=300 2>/dev/null | grep Error; then
   echo "hmy download failed"
   rm -f hmy
   exit 1
fi

echo "updating using node.sh"
sed -e 's/uname -s/echo Linux/' node.sh > node-linux.sh
echo asdf | bash ./node-linux.sh -S -1 -k asdf > /dev/null 2>&1

for i in bootnode harmony; do
    chmod +x $i
    if dd if=$i count=1 bs=300 2>/dev/null | grep Error; then
       echo "$i download failed"
       rm -f $i
       exit 1
    fi
done

git -P diff harmony-checksums.txt

while read -r line; do
    file=$(echo "$line" | cut -f 1 -d \) | cut -f 2 -d \()
    sum1=$(echo "$line" | cut -f 2 -d ' ')
    sum2=$(sha256sum $file | cut -f 1 -d " ")
    if [ "$sum1" != "$sum2" ]; then
       echo "$file '$sum1'!='$sum2'"
    fi
done < harmony-checksums.txt

rm -f md5sum.txt::*

popd
