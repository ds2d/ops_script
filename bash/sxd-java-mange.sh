#!/bin/bash
# description: java process manager
# usage: $./java_manager.sh [prcoess name] [start/stop/restart]

. /etc/profile

waitTime=0
process=$1
action=$2

waitExit(){
  while true
  do
    if [ ! -d "/proc/$1" ]
    then
      echo "process is finished"
      break
    else
      waitTime=$(($waitTime+1))
      sleep 1s
      echo "process is alive, waiting..." $waitTime"s"
    fi

    # wait process for 120s
    if [ "$waitTime" -eq 120 ]
    then
      kill -9 $1
      break
    fi
  done
}


#PID=`ps aux | grep "java -jar /opt/java/[c]redit-api.jar" | awk '{print $2}'`
PID=`ps aux | grep $process | grep -v "grep" | grep -v "java_manager" | awk '{print $2}'`
#echo $PID

# start/stop/restart java process
case $action in
  start)
    echo "Starting service..."
    if [ ! $PID ]
    then
      nohup java -jar $process >/tmp/1 2>&1 &  # run in background
      echo "process started..."
    else
      echo "process is already running..."
    fi
  ;;

  stop)
    if [ ! $PID ]
    then
      echo "process is not running..."
    else
      echo "Stoping process..."
      kill $PID
      waitExit $PID
      echo "process stopped..."
    fi
  ;;

  restart)
    if [ ! $PID ]
    then
      echo "process starting..."
      nohup java -jar $process >/tmp/1 2>&1 &
      echo "process started..."
    else
      # stop process
      echo "process stopping..."
      kill $PID
      waitExit $PID
      echo "process stopped..."
      # start process
      echo "process starting..."
      nohup java -jar $process >/tmp/1 2>&1 &
      echo "process started..."
    fi
  ;;
esac
