#!/bin/bash

set -x
PROJECT=`gcloud config list --format 'value(core.project)' 2>/dev/null`
ZONE='us-east4-a'
for INSTANCE in blue-1 red-1; do
  gcloud compute --project=${PROJECT} instances create ${INSTANCE} \
    --zone=${ZONE} \
    --machine-type=n1-standard-1 \
    --subnet=default  \
    --image=rhel-7-v20190312 \
    --image-project=rhel-cloud \
    --boot-disk-size=20GB \
    --boot-disk-type=pd-standard \
    --boot-disk-device-name=instance-3
done
gcloud compute --project=${PROJECT} instances add-tags red-1 --zone us-east4-a --tags red
gcloud compute --project=${PROJECT} instances add-tags blue-1 --zone us-east4-a --tags blue
gcloud compute --project=${PROJECT} firewall-rules create red-allow-4444 --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:4444 --source-ranges=10.150.0.0/32 --target-tags=red
gcloud compute --project=${PROJECT} firewall-rules create blue-allow-http --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=10.150.0.0/32 --target-tags=blue
