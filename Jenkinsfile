pipeline {
    agent any

    tools {
       go "1.24.1"
    }

        stages {
            stage('Test') {
                  steps {
                       sh "go test ./..."
                  }
            }
        stage('Build') {
            steps {
                sh "go build main.go"
            }
        }
        stage('Deploy to Target') {
            steps {
                withCredentials([sshUserPrivateKey(
                    credentialsId: 'target-ssh-key',
                    keyFileVariable: 'SSH_KEY'
                )]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no -i $SSH_KEY laborant@target "sudo systemctl stop main.service"
                        scp -o StrictHostKeyChecking=no -i $SSH_KEY main laborant@target:~/main
                        ssh -o StrictHostKeyChecking=no -i $SSH_KEY laborant@target "sudo systemctl start main.service"
                    """
                }
            }
        }
    }
}
