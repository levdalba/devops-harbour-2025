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
                        # Stop service if exists
                        ssh -o StrictHostKeyChecking=no -i $SSH_KEY laborant@target "sudo systemctl stop main.service || true"
        
                        # Copy binary
                        scp -o StrictHostKeyChecking=no -i $SSH_KEY main laborant@target:/home/laborant/main
        
                        # Copy systemd unit file
                        scp -o StrictHostKeyChecking=no -i $SSH_KEY main.service laborant@target:/tmp/main.service
        
                        # Move systemd file into place (requires sudo)
                        ssh -o StrictHostKeyChecking=no -i $SSH_KEY laborant@target "sudo mv /tmp/main.service /etc/systemd/system/main.service"
        
                        # Reload systemd
                        ssh -o StrictHostKeyChecking=no -i $SSH_KEY laborant@target "sudo systemctl daemon-reload"
        
                        # Enable service
                        ssh -o StrictHostKeyChecking=no -i $SSH_KEY laborant@target "sudo systemctl enable main.service"
        
                        # Start service
                        ssh -o StrictHostKeyChecking=no -i $SSH_KEY laborant@target "sudo systemctl start main.service"
                    """
                }
            }
        }
    }
}
