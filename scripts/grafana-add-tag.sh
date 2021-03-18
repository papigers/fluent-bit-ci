#!/bin/bash

set -ex
START_DATE=$(date +%s%N | cut -b1-13)

curl -X POST https://fluentbit.grafana.net/api/annotations \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer ${GRAFANA_CLOUD_TOKEN}" \
     --data @- << EOF
     {
       "time":${START_DATE},
       "tags":["commit-master"],
       "text":"Commit: ${COMMIT_ID}, message: ${COMMIT_MESSAGE}"
     }
EOF
