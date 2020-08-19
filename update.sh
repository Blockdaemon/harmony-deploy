#!/usr/bin/env bash
OS=$(uname -s)

update() {
    os=$1
    mkdir -p files/bin/${os}
    pushd files/bin/${os} > /dev/null
    echo "[getting wrappers]"
    for i in node.sh tui; do
      curl -SsLO https://harmony.one/$i
      chmod +x $i
    done

    for i in go-sdk/master/scripts/hmy.sh; do
        curl -SsLO https://raw.githubusercontent.com/harmony-one/$i
        chmod +x $(basename $i)
    done

    echo "[updating hmy using patched hmy-${os}.sh]"
    sed -e "s/curl /curl -sS /;s/uname -s/echo ${os}/" hmy.sh > hmy-${os}.sh
    bash ./hmy-${os}.sh -d
    if dd if=hmy count=1 bs=300 2>/dev/null | grep Error; then
       echo "hmy download failed"
       rm -f hmy
       exit 1
    fi

    echo "[updating using patched node-${os}.sh]"
    if $CLEAN; then
       > staging/md5sum.txt        # force download
    fi
    sed -e "s/uname -s/echo ${os}/" node.sh > node-${os}.sh
    bash ./node-${os}.sh -d

    echo "[checking result]"
    for i in staging/bootnode staging/harmony; do
        chmod +x $i
        if dd if=$i count=1 bs=300 2>/dev/null | grep Error; then
           echo "$i [ERR: download failed]"
           rm -f $i
           exit 1
        fi
    done

    git -P diff staging/harmony-checksums.txt

    while read -r line; do
        file=$(echo "$line" | cut -f 1 -d \) | cut -f 2 -d \()
        sum1=$(echo "$line" | cut -f 2 -d ' ')
        sum2=$(sha256sum staging/$file | cut -f 1 -d " ")
        if [ "$sum1" != "$sum2" ]; then
           echo "$file '$sum1'!='$sum2'"
        fi
    done < staging/harmony-checksums.txt

    rm -f staging/md5sum.txt::*

    popd > /dev/null
}

usage() {
   cat<<-EOT
Usage: $0 [options]

Options:
   -c       force re-download harmony binary
   -h       print this help message

EOT
   exit 0
}

CLEAN=false

while getopts ":ch" opt; do
   case $opt in
      c) CLEAN=true;;
      *) usage;;
   esac
done

update Linux
if [ "${OS}" != "Linux" ]; then
  echo "Not on Linux. Downloading native files"
  update "${OS}"
fi
