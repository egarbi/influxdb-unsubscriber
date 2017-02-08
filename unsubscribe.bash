#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
 echo "Usage $0 db retention_policy"
 exit 1
fi

db=$1
retention_policy=$2

curl http://localhost:8086/query\?pretty\=true --data-urlencode "q=show subscriptions" |grep -A1 ${retention_policy}| grep kapacitor | sed 's/"\|,//g' | awk '{print $1}' > lista_suscriptions.txt

for i in `cat lista_suscriptions.txt`; do echo curl "http://localhost:8086/query --data-urlencode 'q=drop subscription \"$i\" on \"${db}\".\"${retention_policy}\"'"|bash -x; done
