#!groovy

pipeline {
    agent any

    environment {
        BASE_DIR=pwd()
        PROJECT_NAME='kubernetes'
        HARBOR_SERVER='192.168.2.30'
        REPOSITORY='https://github.com/bookgh/k8s-app.git'
    }
    stages {
        stage('获取代码') {
            steps {
                println "checkout"
                deleteDir()
                git "${REPOSITORY}"
            }
        }
        stage('生成镜像 & 上传镜像') {
            steps {
                println "build & push"
                sh """
                cd ${BASE_DIR}/zookeeper && time make debian
                cd ${BASE_DIR}/kafka && time make debian
                cd ${BASE_DIR}/fdfs && time make
                cd ${BASE_DIR}/storm && time make
                cd ${BASE_DIR}/hadoop && time make
                cd ${BASE_DIR}/hbase && time make
                cd ${BASE_DIR}/opentsdb && time make
                cd ${BASE_DIR}/hazelcast-kubernetes && time make
                """
            }
        }
        stage('获取公共镜像') {
            steps {
                println "build & push"
                sh "${BASE_DIR}/google-samples/run.sh"
            }
        }
    }
}
