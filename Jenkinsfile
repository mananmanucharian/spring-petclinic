pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials-id')
    }

    stages {
        stage('Build') {
            steps {
                script {
                    def app = docker.build("myapp:${env.BUILD_ID}")
                }
            }
        }

        stage('Push') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        app.push("latest")
                        app.push("${env.BUILD_ID}")
                    }
                }
            }
        }
    }
}
