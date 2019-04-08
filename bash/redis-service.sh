#!/bin/sh

#Configurations injected by install_server below....

###############
# SysV Init Information
# chkconfig: - 58 74
# description: redis_6379 is the redis daemon.
### BEGIN INIT INFO
# Provides: redis_6379
# Required-Start: $network $local_fs $remote_fs
# Required-Stop: $network $local_fs $remote_fs
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Should-Start: $syslog $named
# Should-Stop: $syslog $named
# Short-Description: start and stop redis_6379
# Description: Redis daemon
### END INIT INFO

EXEC=/wdzj/java/lib/redis/bin/redis-server
CLIEXEC=/wdzj/java/lib/redis/bin/redis-cli
PIDFILE=/wdzj/java/lib/redis/redis.pid
PID=`ps -ef|grep -v grep|grep redis-server|awk '{print $2}'`
CONF="/wdzj/java/lib/redis/redis.conf"
REDISPORT="6379"
PASSWORD="wdzj2014"


case "$1" in
    start)
        #if [ -f $PIDFILE ]
        if [ ! -z $PID ]
        then
            echo "$PIDFILE exists, process is already running or crashed"
        else
            echo "Starting Redis server..."
            rm -f $PIDFILE
            $EXEC $CONF
        fi
        ;;
    stop)
        if [ -z $PID ]
        then
            echo "$PIDFILE does not exist, process is not running"
        else
            #PID=$(cat $PIDFILE)
            echo "Stopping ..."
            $CLIEXEC -a $PASSWORD -p $REDISPORT shutdown
            rm -f $PIDFILE
            while [ -x /proc/${PID} ]
            do
                echo "Waiting for Redis to shutdown ..."
                sleep 1
            done
            echo "Redis stopped"
        fi
        ;;
    status)
        #PID=$(cat $PIDFILE)
        if [ -z ${PID} ]
        then
            echo 'Redis is not running'
        else
            echo "Redis is running ($PID)"
        fi
        ;;
    restart)
        $0 stop
        $0 start
        ;;
    *)
        echo "Please use start, stop, restart or status as first argument"
        ;;
esac
