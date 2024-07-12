pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credential')
        GIT_COMMIT_SHORT = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
        BRANCH_NAME = "${env.BRANCH_NAME}"
    }

    stages {
        stage('Checkstyle') {
            when {
                not { branch 'main' }
            }
            steps {
                script {
                    docker.image('maven:3.6.3-jdk-11').inside {
                        sh 'mvn checkstyle:checkstyle'
                        archiveArtifacts artifacts: '**/target/checkstyle-result.xml', allowEmptyArchive: true
                    }
                }
            }
        }

        stage('Test') {
            when {
                not { branch 'main' }
            }
            steps {
                script {
                    docker.image('maven:3.6.3-jdk-11').inside {
                        sh 'mvn test'
                    }
                }
            }
        }

        stage('Build') {
            when {
                not { branch 'main' }
            }
            steps {
                script {
                    docker.image('maven:3.6.3-jdk-11').inside {
                        sh 'mvn clean package -DskipTests'
                    }
                }
            }
        }

        stage('Create Docker Image') {
            steps {
                script {
                    def imageTag = BRANCH_NAME == 'main' ? 'latest' : GIT_COMMIT_SHORT
                    docker.build("mananmanucharian474/spring-petclinic:${imageTag}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        def imageTag = BRANCH_NAME == 'main' ? 'latest' : GIT_COMMIT_SHORT
                        docker.image("mananmanucharian474/spring-petclinic:${imageTag}").push()
                    }
                }
            }
        }
    }
}

