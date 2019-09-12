#!/bin/bash

harbor=192.168.2.30

function replace(){
  if [ $# -eq 4 ];then
    tag="$4"
    name="$3"
    local_project="$1" 
    remote_project="$2" 
    docker pull $remote_project/$name:$tag
    docker tag $remote_project/$name:$tag $harbor/$local_project/$name:$tag
    docker push $harbor/$local_project/$name:$tag
    docker rmi $remote_project/$name:$tag
    docker rmi $harbor/$local_project/$name:$tag
  elif [ $# -eq 3 ];then
    tag="$3"
    name="$2"
    local_project="$1"
    docker pull $name:$tag
    docker tag $name:$tag $harbor/$local_project/$name:$tag
    docker push $harbor/$local_project/$name:$tag
    docker rmi $name:$tag
    docker rmi $harbor/$local_project/$name:$tag
  fi
}



replace kubernetes jmgao1983 nfs-client-provisioner latest
replace kubernetes bookgh xtrabackup 1.0
replace kubernetes redis 4.0.11-stretch
replace kubernetes mysql 5.7.20

replace kubernetes busybox latest
replace kubernetes busybox 1.29.3
replace kubernetes mongo 3.6
replace kubernetes unguiculus mongodb-install 0.7
replace kubernetes jmgao1983 elasticsearch 6.4.0
replace kubernetes eipwork kuboard latest
replace kubernetes sheepkiller kafka-manager latest
replace kubernetes newnius docker-proxy latest
