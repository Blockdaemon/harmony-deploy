#!/bin/bash
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
sed -i -e 's/curl /curl -sS /' hmy.sh
./hmy.sh -d > /dev/null # 2>&1
if dd if=hmy count=1 bs=300 2>/dev/null | grep Error; then
   rm -f hmy
fi

echo asdf | ./node.sh -S -1 -k asdf > /dev/null 2>&1
chmod +x harmony
if dd if=harmony count=1 bs=300 2>/dev/null | grep Error; then
   rm harmony
fi

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
