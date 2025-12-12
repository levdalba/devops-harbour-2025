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
        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig(credentialsId: 'k8s-token', serverUrl: 'https://kubernetes:6443') {
                    script {
                        sh 'kubectl run myapp --image=ttl.sh/myapp:1h --dry-run=client -o=yaml > pod.yaml'
                        sh 'kubectl apply -f pod.yaml --force'
                    }
                }
            }
        }
    }
}
