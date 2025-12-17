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
                sshagent(['ec2-ssh-key']) {
                    script {
                        def remoteIp = '13.251.126.56' 
                        
                        sh """
                            ssh -o StrictHostKeyChecking=no ec2-user@${remoteIp} "
                                docker pull ttl.sh/myapp:1h && \\
                                docker stop myapp || true && \\
                                docker rm myapp || true && \\
                                docker run -d --name myapp -p 4444:4444 ttl.sh/myapp:1h
                            "
                        """
                    }
                }
            }
        }
    }
}
