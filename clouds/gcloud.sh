#!/bin/bash

. local.env

#scopes="--scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append"
#affinity="--reservation-affinity=any"

for ((i=0; i<"${#nodes[@]}"; i++)); do
node=${nodes[i]}
owner=${owners[i]}
gcloud beta compute --project=${project} instances create ${node} \
--zone=${zone} --machine-type=${machine_type} --subnet=${subnet} \
--tags=harmony \
--labels=env=production,chain=harmony,owner=${owner},blockchain_gid=${node},creator=${USER} \
--network-tier=PREMIUM --maintenance-policy=MIGRATE \
--service-account=${service_account} \
--image=${image} \
--image-project=ubuntu-os-cloud --boot-disk-size=10GB \
--boot-disk-type=pd-standard --boot-disk-device-name=${node} \
--create-disk=mode=rw,size=500,type=projects/${project}/zones/${zone}/diskTypes/pd-standard,name=${node}-data,device-name=${node}-data \
${scopes} ${affinity}
done
