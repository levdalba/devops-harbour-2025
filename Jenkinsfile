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
        stage('Deploy') {
            steps {
                sshagent(credentials: ['target-ssh-key']) {
                    sh 'scp -o StrictHostKeyChecking=no main laborant@target:~'
                }
            }
        }
    }
}
