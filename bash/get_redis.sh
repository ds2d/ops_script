#/bin/bash
# get redis keys 
# redis-cli -h {host} -p {port} {command}
#/usr/local/bin/redis-cli -h redis.services.com -p 6379 -a $password type value

redis_cli=/usr/local/bin/redis-cli
redis_port=6379
redis_password=${password}
redis_id=$1
redis_host=$redis_id.redis.rds.aliyuncs.com
# cmd_type=$2
# cmd_value=$3

shift
$redis_cli -h $redis_host -p $redis_port  -a $redis_password $@
