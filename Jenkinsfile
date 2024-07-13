pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'mananmanucharian474/mr'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Checkstyle') {
            steps {
                script {
                    // Run Maven Checkstyle plugin
                    sh 'mvn checkstyle:checkstyle'
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: '**/target/checkstyle-result.xml', allowEmptyArchive: true

                    publishHTML(target: [
                        reportName : 'Checkstyle Report',
                        reportDir  : 'target/site',
                        reportFiles: 'checkstyle.html',
                        alwaysLinkToLastBuild: true,
                        keepAll: true
                    ])
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    sh 'mvn test'
                }
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    sh 'mvn clean package -DskipTests'
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: '**/target/*.jar', allowEmptyArchive: true
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    def GIT_COMMIT_SHORT = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    sh "docker build -t ${DOCKER_HUB_REPO}:${GIT_COMMIT_SHORT} ."

                    
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                        sh 'echo $DOCKER_HUB_PASSWORD | docker login -u $DOCKER_HUB_USERNAME --password-stdin'
                    }

                    sh "docker push ${DOCKER_HUB_REPO}:${GIT_COMMIT_SHORT}"
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
