#!/bin/bash
# Deploy project on jenkins web
export PATH=/bin:/usr/bin:/sbin:/usr/sbin

NOW=`date +%F-%H.%M.%S`
TAG=jenkins
HOST=java_01
SSH_PORT=22

DEPLOY_LIST="java_jar java_02"
LOG_FILE=/var/log/jenkins/deploy_log/deploy_${JOB_NAME}_$NOW.log

declare -A PROJECT_TARGET=(["java_jar"]="java_jar/target/java_jar.zip"   
                           ["java_02"]="java_02/target/java_02.zip")


deploy() {
    #dir=$PWD
    echo "git pull env_files"
    cd /var/lib/jenkins/workspace/env/test_env
    /java/lib/git/bin/git pull
    echo "scp env file"
    scp -r -P $SSH_PORT /var/lib/jenkins/workspace/env/test_env/env root@$HOST:/root/install/
    echo "scp env file Finished!"
    
    # dev 环境
    #echo "git pull env_files"
    #cd /var/lib/jenkins/workspace/env/env
    #/java/lib/git/bin/git pull
    #echo "scp env file"
    #scp -r -P $SSH_PORT /var/lib/jenkins/workspace/env/env root@$HOST:/root/install/
    #echo "scp env file Finished!"

    cd $WORKSPACE
    echo "Deploying $1" >> $LOG_FILE
    ls -alh ${PROJECT_TARGET["$1"]}
    if [ "$?" -ne 0 ];then
        echo  ${PROJECT_TARGET["$1"]} Does not exist,Please check it!!!
        exit 10
    else
        echo "OK!"
    fi
    scp -P $SSH_PORT ${PROJECT_TARGET["$1"]} root@$HOST:/root/install/$1-$TAG.$NOW.zip
    echo "tranclate $1-$TAG.$NOW.zip file Finished!"
    ssh -p $SSH_PORT root@$HOST "bash -l -c \"/root/install/install-$1.sh $1-$TAG.$NOW.zip\""
    echo "Deployed $1" >> $LOG_FILE
}


for proj in ${DEPLOY_LIST[@]}
do
    echo "deploying $proj" >> $LOG_FILE
    deploy $proj
    sleep 5
    echo "Deploy $proj Finished"
done

