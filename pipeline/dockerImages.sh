#!/bin/bash
# build images

project=$1
version=$(date +%F)
cd /root/install/
#mv $2 $1.zip

#[[ "$#" != 2 ]] && echo "参数错误"  && exit 1 || echo "ok"
if [[ "$#" != 2 ]]; then
    echo "参数错误!"
    exit 1
else
    echo "ok!"
fi


echo "Create Dockerfile......"
cat >/root/install/Dockerfile <<EOF 
FROM 192.168.30.110/library/jdk:1.8


ADD $2 /data/
WORKDIR /data
RUN /usr/bin/unzip $2
COPY run.sh /root/
RUN chmod +x /root/run.sh

CMD ["sh", "/root/run.sh"]
EOF

echo "Build Image......"
docker build -t 192.168.30.110/library/$1:${version} .

echo "Push image harbor storage......"
docker push 192.168.30.110/library/$1:${version}
