#!/bin/bash

TOP=$(realpath $(dirname $0)/..)
HMY=${TOP}/files/bin/hmy

# Generate a given number of bls keys for a given shard
version="0.0.1"
script_name="generate.sh"

#
# Arguments/configuration
#
usage() {
   cat << EOT
Usage: $0 [option] command
Options:
   --count    count   the number of bls keys to generate
   --shard    shard   the shard to generate bls keys for
   --node     node    what network/node to use
   --help             print this help section
EOT
}

while [ $# -gt 0 ]
do
  case $1 in
  --count) count="$2" ; shift;;
  --shard) shard="$2" ; shift;;
  --node) node="$2" ; shift;;
  -h|--help) usage; exit 1;;
  (--) shift; break;;
  (-*) usage; exit 1;;
  (*) break;;
  esac
  shift
done

initialize() {
  if [ -z "$count" ]; then
    count=1
  fi

  if [ -z "$shard" ]; then
    shard=0
  fi

  if [ -z "$node" ]; then
    node="https://api.s0.t.hmny.io"
  fi

  unset generated
  unset keys

  declare -ag keys
  generated=0
  packages=(jq curl)
}

check_dependencies() {
  if ! test -x ${HMY}; then
    echo "can't execute ${HMY}"
    echo "You need hmy to be able to use this script, please install it:"
    echo "curl -LO https://harmony.one/hmycli && mv hmycli hmy && chmod u+x hmy"
    exit 1
  fi

  local missing_packages=()
  for package in "${packages[@]}"; do
    if ! command -v "${package}" >/dev/null 2>&1; then
      missing_packages+=($package)
    fi
  done

  if (( ${#missing_packages[@]} )); then
    need_to_install=${missing_packages[@]}
    echo "The following packages need to be installed: ${need_to_install}"
    echo "Please install them using:"

    if command -v apt-get >/dev/null 2>&1; then
      echo "sudo apt-get install -y ${need_to_install}"
    fi

    if command -v yum >/dev/null 2>&1; then
      echo "sudo yum install ${need_to_install}"
    fi

    exit 1
  fi
}

generate_keys() {
  echo "Generating a total of ${count} BLS key(s) for shard ${shard} using node ${node}"

  while (( generated < count )); do
    bls_key=$(${HMY} keys generate-bls-key | jq '.["public-key"]' | tr -d '"')
    generated_shard=$(${HMY} --node ${node} utility shard-for-bls ${bls_key} | jq '.["shard-id"] | tonumber')

    if (( generated_shard == shard )); then
      keys+=("${bls_key}")
      ((generated++))
      mkdir -p shard-${shard}/
      mv ${bls_key}.key shard-${shard}/
    else
      rm -rf ${bls_key}.key
    fi
  done

  if (( ${#keys[@]} )); then
    echo "Generated the following bls keys for shard ${shard}:"

    for key in "${keys[@]}"; do
      echo "${key}"
    done
  fi

  echo ""
}

run() {
  initialize
  check_dependencies
  generate_keys
}

run
