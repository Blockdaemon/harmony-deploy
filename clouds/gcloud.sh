#!/bin/bash

set -e
. local.env

#scopes="--scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append"
#affinity="--reservation-affinity=any"

for ((i=0; i<"${#nodes[@]}"; i++)); do
node=${nodes[i]}
owner=${owners[i]}
zone=${zones[i]}
region=${zone:0:-2}
echo "creating ${node}-ip in ${region}"
gcloud compute addresses create ${node}-ip --project=${project} --region=${region} || true
echo "creating ${node} in ${zone}"
gcloud beta compute --project=${project} instances create ${node} \
--zone=${zone} --machine-type=${machine_type} --subnet=${region} \
--tags=harmony \
--address=${node}-ip \
--labels=env=production,chain=harmony,owner=${owner},xid=${node},creator=${USER} \
--network-tier=PREMIUM --maintenance-policy=MIGRATE \
--service-account=${service_account} \
--image-family=${image_family} \
--image-project=ubuntu-os-cloud --boot-disk-size=10GB \
--boot-disk-type=pd-standard --boot-disk-device-name=${node} \
--create-disk=mode=rw,size=200,type=projects/${project}/zones/${zone}/diskTypes/pd-standard,name=${node}-data,device-name=${node}-data \
${scopes} ${affinity}
done
