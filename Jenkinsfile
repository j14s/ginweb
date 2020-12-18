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
    pollSCM '* * * * *'
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

    stage('Container') {
      steps {
        container('kaniko') {
          sh """#!/busybox/sh

            IMAGE_ID=core.c7d.net/c7d/ginweb && \
            export DOCKER_CONFIG=/kaniko/.docker && \
            /kaniko/executor \
              --context $(pwd) \
              --dockerfile $(pwd)/Dockerfile \
              --destination ${IMAGE_ID}:${VERSION} \
              --force
          """
        }
      }
    }

    stage('deploy') {
      steps {
        container('helm') {
          sh "helm repo update"
          sh "helm search repo c7d/ginweb --version 0.1.4"
          withKubeConfig([credentialsId: 'c7d-deploy']) {
          sh """#!/bin/bash

            echo "VERSION: 0.1.4"
            helm upgrade  --kube-context c7d \
                          --namespace ginweb \
                          --reset-values --install \
                          --wait --timeout 300s \
                          --version 0.1.4 \
                          --set image.tag=${VERSION} \
                          ginweb \
                          c7d/ginweb

          """
          }
        }
      }
    }

    stage('Finished') {
      steps {
        container('busybox') {
          echo "Finished"
        }
      }
    }
  }
}
