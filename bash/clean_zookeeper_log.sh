#!/bin/bash
# clean zookeeper snapshot,log 

#snapshot file dir
dataDir=/java/zkdata/version-2
#tran log dir
dataLogDir=/java/zkdata/version-2

#Leave 500 files
count=500
count=$[$count+1]

ls -t $dataLogDir/log.* | tail -n +$count | xargs rm -f
ls -t $dataDir/snapshot.* | tail -n +$count | xargs rm -f
