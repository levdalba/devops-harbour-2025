pipeline {
    agent any
    stages {
        stage('Build & Push') {
            steps {
                script {
                    sh 'docker build . --tag ttl.sh/myapp:1h'
                    sh 'docker push ttl.sh/myapp:1h'
                }
            }
        }
        stage('Deploy to EC2') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'MY_SSH_KEY')]) {
                    script {
                        def remoteIp = '13.251.126.56'
                        
                        sh """
                            ssh -i \$MY_SSH_KEY -o StrictHostKeyChecking=no ec2-user@${remoteIp} "
                                # 1. Install Docker (if missing)
                                sudo yum update -y
                                sudo yum install -y docker
                                sudo systemctl start docker
                                sudo systemctl enable docker
                                
                                # 2. Run the App (using sudo to ensure permissions work immediately)
                                sudo docker pull ttl.sh/myapp:1h
                                sudo docker stop myapp || true
                                sudo docker rm myapp || true
                                sudo docker run -d --name myapp -p 4444:4444 ttl.sh/myapp:1h
                            "
                        """
                    }
                }
            }
        }
    }
}
