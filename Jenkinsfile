pipeline {
    agent any

    tools {
        go "1.24.1"
    }

    environment {
        IMAGE_NAME = "ttl.sh/levdalba-devops-harbour:2h"
        CONTAINER_NAME = "devops-app"
    }

    stages {
        stage('Test') {
            steps {
                sh 'go test ./...'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME} ."
                }
            }
        }

        stage('Push to Registry') {
            steps {
                script {
                    sh "docker push ${IMAGE_NAME}"
                }
            }
        }

        stage('Deploy to Docker VM') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'target-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                    script {
                        def remote = "laborant@docker" 

                        sh "ssh -o StrictHostKeyChecking=no -i $SSH_KEY ${remote} 'docker pull ${IMAGE_NAME}'"

                        sh "ssh -o StrictHostKeyChecking=no -i $SSH_KEY ${remote} 'docker stop ${CONTAINER_NAME} || true'"
                        sh "ssh -o StrictHostKeyChecking=no -i $SSH_KEY ${remote} 'docker rm ${CONTAINER_NAME} || true'"
                        
                        sh "ssh -o StrictHostKeyChecking=no -i $SSH_KEY ${remote} 'docker run -d -p 4444:4444 --name ${CONTAINER_NAME} ${IMAGE_NAME}'"
                    }
                }
            }
        }
    }
}
