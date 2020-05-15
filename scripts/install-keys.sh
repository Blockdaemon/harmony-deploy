#!/bin/bash

set -e
if [ $# -ne 1 ]; then
    echo "usage: $0 account-name"
    exit 1
fi

mkdir -p .hmy_cli/account-keys/$1/
cp -v $1/one*/* .hmy_cli/account-keys/$1/
cp -v $1/passphrase .hmy_cli/account-keys/$1/
