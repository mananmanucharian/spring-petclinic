pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = "localhost:8084"
        DOCKER_REPO = "mr/spring-petclinic"
    }

    stages {
        stage('Checkstyle') {
            steps {
                script {
                    // Run Maven Checkstyle plugin
                    sh 'mvn checkstyle:checkstyle'
                }
            }
            post {
                always {
                    // Archive Checkstyle reports
                    archiveArtifacts artifacts: 'target/checkstyle-result.xml', allowEmptyArchive: true
                    // Publish Checkstyle report
                    checkstyle pattern: 'target/checkstyle-result.xml'
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Run tests with Maven
                    sh 'mvn test'
                }
            }
            post {
                always {
                    // Archive test reports
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    // Build without running tests
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Create Docker Image') {
            steps {
                script {
                    // Get short commit hash
                    def shortCommit = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    
                    // Build the Docker image
                    sh "docker build -t ${DOCKER_REGISTRY}/${DOCKER_REPO}:${shortCommit} ."
                    
                    // Push the Docker image to the repository
                    sh "docker push ${DOCKER_REGISTRY}/${DOCKER_REPO}:${shortCommit}"
                }
            }
        }
    }

    post {
        always {
            // Clean up Docker images to free space
            sh "docker rmi ${DOCKER_REGISTRY}/${DOCKER_REPO}:${shortCommit} || true"
        }
    }
}
