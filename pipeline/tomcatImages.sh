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
cat >/root/install/Dockerfile.$project  <<EOF 
FROM 192.168.30.110/library/tomcat:8.5


ADD $2 /
RUN unzip -d /usr/local/tomcat/webapps/ROOT /$2

#EXPOSE 8080

#CMD ["/usr/local/tomcat/bin/catalina.sh","run"]
EOF

echo "Build Image......"
docker build -f /root/install/Dockerfile.$project -t 192.168.30.110/library/$project:${version} .

echo "Push image harbor storage......"
docker push 192.168.30.110/library/$project:${version}
