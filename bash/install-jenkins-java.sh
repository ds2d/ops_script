#!/bin/bash
# Deploy project on jenkins web
# version: v2
# date: 2019-06-19

export PATH=/bin:/usr/bin:/sbin:/usr/sbin

NOW="$(date +%F-%H.%M.%S)"
TAG=jenkins
HOSTS='host01 host02'
SSH_PORT=22
ENV="test_env"

DEPLOY_LIST="project01 project02"
LOG_FILE=/var/log/jenkins/deploy_log/deploy_${JOB_NAME}_$NOW.log

declare -A PROJECT_TARGET=(["peoject01"]="peoject01/target/peoject01.zip"   
                           ["peoject02"]="peoject02/target/project02.zip"
)

test_env() {
  # test env
  echo "Deploy env_files......"
  cd /var/lib/jenkins/workspace/env/test_env
  /wdzj/java/lib/git/bin/git pull
  echo "scp env file"
  scp -r -P $SSH_PORT /var/lib/jenkins/workspace/env/test_env/env root@${HOST}:/root/install/
  echo "scp env file Finished!"
}

dev_env() {
  # dev env
  echo "Deploy env_files......"
  cd /var/lib/jenkins/workspace/env/env
  /wdzj/java/lib/git/bin/git pull
  echo "scp env file"
  scp -r -P $SSH_PORT /var/lib/jenkins/workspace/env/env root@${HOST}:/root/install/
  echo "scp env file Finished!"

}

deploy() {
  for HOST in ${HOSTS[@]}; do
    echo "Deploy ${project} to ${HOST}......"
    # deploy env file
    ${ENV}

    cd ${WORKSPACE}
    echo "Deploying $1" >> $LOG_FILE
    ls -alh ${PROJECT_TARGET["$1"]}

    # 检查maven打包是不是正常完成
    if [ "$?" -ne 0 ]; then
        echo  ${PROJECT_TARGET["$1"]} Does not exist,Please check it!!!
        exit 500
    fi

    # 目的是为了结合本地的监控脚本，重度复用，不用更改
    #PACKAGE=$(ls ${PROJECT_TARGET["$1"]}|awk -F'/' '{print $NF}')
    #scp -P $SSH_PORT ${PROJECT_TARGET["$1"]} root@$HOST:/root/install/$NOW-$PACKAGE
    #ssh -p $SSH_PORT root@$HOST "cd /root/install; ln -fs $NOW-$PACKAGE latest-$PACKAGE"
    #echo "tranclate $NOW-$PACKAGE file Finished!"
    #ssh -p $SSH_PORT root@$HOST "bash -l -c \"/root/install/install-$1.sh latest-$PACKAGE\""
    #echo "Deployed $1" >> $LOG_FILE
    
    # copy 项目包到远程服务器，并启动服务
    scp -P $SSH_PORT ${PROJECT_TARGET["$1"]} root@$HOST:/root/install/$1-$TAG.$NOW.zip
    echo "tranclate $1-$TAG.$NOW.zip file Finished!"
    ssh -p $SSH_PORT root@$HOST "bash -l -c \"/root/install/install-$1.sh $1-$TAG.$NOW.zip\""
    echo "Deployed $1" >> $LOG_FILE
  done
}


for project in ${DEPLOY_LIST[@]}; do
    echo "deploying $project" >> $LOG_FILE
    deploy ${project}
    sleep 5
    echo "Deploy $project Finished"
done
