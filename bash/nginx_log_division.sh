# /bin/bash

logs_path="/wdzj/logs/nginx/"

#以前的日志文件。

log_name="access.log"   

pid_path="/var/run/nginx.pid"



mv ${logs_path}${log_name} ${logs_path}${log_name}_$(date "+%Y-%m-%d").log
mv ${logs_path}error.log ${logs_path}error_$(date "+%Y-%m-%d").log



kill -USR1 `cat ${pid_path}`

#log clean over 7 days 
DATA=`date -d "-7 days" +"%Y-%m-%d"`
cd /wdzj/logs/nginx/
rm -rf access.log_${DATA}.log
rm -rf error_${DATA}.log

