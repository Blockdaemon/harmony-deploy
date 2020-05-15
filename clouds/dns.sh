#!/bin/bash

set -e

. local.env

if [ -z "${dns_zone}" ]; then
    echo "dns_zone" undefined
    exit 1
fi

rm -f transaction.yaml
gcloud dns --project ${project} record-sets transaction start -z bdi-sh
for ((i=0; i<"${#nodes[@]}"; i++)); do
    node=${nodes[i]}
    owner=${owners[i]}
    zone=${zones[i]}
    ip=$(gcloud compute addresses describe ${node}-ip --region=${zone:0:-2} --format=json | jq -r .address)
    if [ -z "${ip}" ]; then
	echo "can't find ${node}-ip in ${zone}"
	rm -f transaction.yaml
	exit -1
    fi

    echo ${node}.${dns_zone} A $ip
    gcloud dns --project ${project} record-sets transaction add $ip -z bdi-sh --name=${node}.${dns_zone} --type=A --ttl=3600
done
gcloud dns --project ${project} record-sets transaction execute -z bdi-sh
