pipeline {

  agent {
    kubernetes {
      label 'ginweb'
      defaultContainer 'jnlp'
      yamlFile 'KubernetesPod.yaml'
    }
  }

  options {
    buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '5')
    disableConcurrentBuilds()
  }

  triggers {
    pollSCM '*/5 * * * *'
  }

  stages {
    stage('Init') {
      steps {
        container('git') {
          script {
            VERSION = sh(returnStdout: true, script: "git describe --always --long --dirty").trim()
          }
          echo "Starting container chart mod and deploy"
        }
      }
    }

    stage('test|build') {
      steps {
        container('golang') {
            sh "env | grep GO"
            sh "pwd && ls -l"
            sh "go get -v"
            sh "go test -v"
        //   sh "cd src/kda && go get -d github.com/prometheus/client_golang/prometheus/promhttp github.com/gorilla/mux github.com/gorilla/handlers"
            sh "CGO_ENABLED=0 GOOS=linux go build -ldflags=\"-X main.version=${VERSION}\" -a -installsuffix cgo"
        //   sh "pwd && ls -l"
        //   sh "cd  src/kda && cp kda-demo-app /home/jenkins/workspace/kda/containers/kda-app/"
        }
      }
    }

    // stage('chart') {
    //   steps {
    //     container('helm') {
    //       sh "sed -i -e s/XVERSIONX/${VERSION}/g Chart.yaml"
    //       sh "sed -i -e s/XVERSIONX/${VERSION}/g values.yaml"
    //       sh "helm repo update"
    //       sh "helm push ./ c7d"
    //     }
    //   }
    // }

    // stage('deploy') {
    //   steps {
    //     container('helm') {
    //       sh "helm repo update"
    //       sh "helm search repo c7d/smokeping --version ${VERSION}"
    //       withKubeConfig([credentialsId: 'c7d-deploy']) {
    //       sh """#!/bin/bash

    //         echo "VERSION: ${VERSION}"
    //         helm upgrade  --kube-context c7d \
    //                       --namespace smokeping \
    //                       --reset-values --install \
    //                       --wait --timeout 300s \
    //                       --version ${VERSION} \
    //                       smokeping \
    //                       c7d/smokeping

    //       """
    //       }
    //     }
    //   }
    // }

    stage('Finished') {
      steps {
        container('busybox') {
          echo "Finished"
        }
      }
    }
  }
}
