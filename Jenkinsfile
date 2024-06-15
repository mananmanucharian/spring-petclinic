pipeline {
    agent any

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

        // If Docker image creation and pushing stages are needed in the future, uncomment and use the following:
        // stage('Create Docker Image') {
        //     steps {
        //         script {
        //             // Get short commit hash
        //             def shortCommit = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    
        //             // Build the Docker image
        //             sh "docker build -t localhost:8083/main/spring-petclinic:${shortCommit} ."
                    
        //             // Push the Docker image to the main repository
        //             sh "docker push localhost:8083/main/spring-petclinic:${shortCommit}"
        //         }
        //     }
        // }
    }

    post {
        always {
            // Optional: Clean up Docker images to free space if needed
            // sh "docker image prune -f || true"
        }
    }
}
