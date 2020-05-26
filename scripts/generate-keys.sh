#!/bin/bash

. $(dirname $0)/functions

set -e
if [ $# -ne 1 ]; then
    echo "usage: $0 account-name"
    exit 1
fi

export HOME=.
keydir=$($HMY keys location)
if [ ! -r $1/passphrase ]; then
    passphrase=$(diceware -d - --no-caps)
    mkdir -p $1
    echo "${passphrase}" > $1/passphrase
    chmod og-r $1/passphrase
fi

rm -rf $keydir
$HMY keys add $1 --passphrase-file $1/passphrase > out
account=$(tail -1 out | cut -f 3 -d " ")
mkdir -p $1/$account
mv $keydir/$1/UTC* $1/$account/
head -3 out | tail -1 > $1/$account/recovery
chmod -R og-rx $1/$account
rm -rf $keydir out

# vim: sw=4
