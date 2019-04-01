#!/bin/bash
# Delete 20 days ago elk index.log

DATE=`date -d "30 days ago" +%Y-%m-%d`
 
curl -s  -XGET http://es:9200/_cat/indices?v| grep $DATE | awk -F '{print $3}' >/tmp/elk.log
 
for elk in $(cat /tmp/elk.log)
do
    curl  -XDELETE  "http://es:9200/$elk"
done
