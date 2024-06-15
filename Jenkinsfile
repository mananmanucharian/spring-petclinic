pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "spring-petclinic"
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the repository
                checkout scm
            }
        }
        stage('Checkstyle') {
            steps {
                script {
                    // Run Maven Checkstyle
                    sh 'mvn checkstyle:check'
                }
                // Archive the Checkstyle report
                archiveArtifacts artifacts: 'target/checkstyle-result.xml', allowEmptyArchive: true
            }
            post {
                always {
                    // Publish the Checkstyle report (if available)
                    publishHTML([
                        allowMissing: true,
                        alwaysLinkToLastBuild: true,
                        keepAll: true,
                        reportDir: 'target/site',
                        reportFiles: 'checkstyle.html',
                        reportName: 'Checkstyle Report'
                    ])
                }
            }
        }
        stage('Build') {
            steps {
                script {
                    // Run Maven build without tests
                    sh 'mvn clean install -DskipTests'
                }
                // Archive the build artifacts (e.g., JAR files)
                archiveArtifacts artifacts: 'target/*.jar', allowEmptyArchive: true
            }
        }
        stage('Test') {
            steps {
                script {
                    // Run Maven tests
                    sh 'mvn test'
                }
                // Archive the test results
                junit 'target/surefire-reports/*.xml'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh "docker build -t ${DOCKER_IMAGE}:${env.BUILD_ID} ."
                }
                // Archive the Docker image
                archiveArtifacts artifacts: 'Dockerfile', allowEmptyArchive: true
            }
        }
    }

    post {
        always {
            // Clean up workspace
            cleanWs()
        }
    }
}
