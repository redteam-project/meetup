#!/bin/bash

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
