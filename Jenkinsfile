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
                withCredentials([sshUserPrivateKey(credentialsId: '0f3b5a5f-9a10-4518-844a-020edf06c136',
                                                   keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no -i "$SSH_KEY" laborant@target "echo connected"
                        scp -o StrictHostKeyChecking=no -i "$SSH_KEY" main laborant@target:~
                    '''
                }
            }
        }
    }
}
