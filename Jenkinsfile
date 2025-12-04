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
                sshagent(['target-ssh-key']) {
                    sh 'ssh -o StrictHostKeyChecking=no laborant@target "sudo systemctl stop main.service"'

                    sh 'scp -o StrictHostKeyChecking=no main laborant@target:~/main'

                    sh 'ssh -o StrictHostKeyChecking=no laborant@target "sudo systemctl start main.service"'
                }
            }
        }
    }
}
