#!/bin/bash

application_id="$1"
api_key="$2"
metric="$3"

nr_endpoint="https://api.newrelic.com/v2/applications/${application_id}.json"

#jobs=$(curl -s -X GET $nr_endpoint -H "X-Api-Key:$api_key")

#'| jq '.application.end_user_summary.response_time'


nr_data_file="/dev/shm/nr_data-${application_id}"
if [ -f $nr_data_file ]; then
    age=`date -d "now - $(stat -c "%Y" $nr_data_file ) secs  " +%s`
else
    age=9999
fi

if [ $age -le 120 ]; then
#   echo $nr_data_file es nuevo
    j=`cat $nr_data_file`
else
#   echo $nr_data_file es viejo
    j=$(curl -s -X GET $nr_endpoint -H "X-Api-Key:$api_key")
    echo $j > $nr_data_file
fi

echo $j | jq $metric
