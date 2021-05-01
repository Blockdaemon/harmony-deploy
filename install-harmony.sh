#!/bin/bash
set -e
OS=$(uname -s)
VER=$(yq -r .harmony_version defaults/main.yml)
mkdir -p files/bin/$OS/harmony
cd files/bin/$OS/harmony

case "${OS}" in
  Linux)
    curl -fs -L https://github.com/harmony-one/harmony/releases/download/v${VER}/harmony -o harmony
    ;;
  Darwin)
    curl -fs -LO https://github.com/harmony-one/harmony/releases/download/v${VER}/harmony-macos-${VER}.zip
    unzip harmony-macos-${VER}.zip
    ;;
  *)
    echo "Unknown OS ${OS}"
    exit 1
    ;;
esac

chmod +x harmony
