#!groovy

pipeline {
    agent any

    environment {
        BASE_DIR=pwd()
        PROJECT_NAME='kubernetes'
        HARBOR_SERVER='192.168.2.30'
        REPOSITORY='https://github.com/bookgh/k8s-app.git'
        BUILD='zookeeper'
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
                echo "--------------- build & push ----- $BUILD"
                if [ -d "$BUILD" ]; then
                    cd "$BUILD" && make
                fi
                """
            }
        }
    }
}
