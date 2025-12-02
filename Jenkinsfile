pipeline {
    agent none

    triggers {
        githubPush()
    }

    environment {
        IMAGE_NAME = "raichu08/myapp"
        IMAGE_TAG = "v${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout Code') {
            agent {
                label 'test1'
            }
            steps {
                echo "Fetching latest code from GitHub..."
                checkout scm
            }
        }

        stage('Build Docker Image') {
            agent {
                    label 'test1'
                 }
            steps {
                script {
                    echo "Building Docker image..."
                    sh """
                        docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    """
                }
            }
        }

        stage('Run Docker Container') {
            agent {
                    label 'test1'
                 }
            steps {
                script {
                    echo "Running container for testing..."
                    sh """
                        docker run -d --name myapp-test -p 80:80 ${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }

        stage('Test Docker Container') {
            agent {
                    label 'test1'
                 }
            steps {
                script {
                    echo "Testing container health..."
                    // Example test: check if container is running
                    sh """
                        sleep 10
                        docker ps | grep myapp-test
                    """
                }
            }
        }

        stage('Push to Dockerhub and Logout'){
            agent {
                    label 'test1'
                }
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'Raichu', 
                        usernameVariable: 'DOCKER_USER', 
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                         sh """
                            set -e
                            echo "Logging into Docker..."
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                            docker push ${IMAGE_NAME}:${IMAGE_TAG}
                            docker logout
                         """
                    }
                }
            }
        }

        stage('Deploy to prod') {
            when {
                expression { currentBuild.currentResult == "SUCCESS" }
            }
            agent {
                label 'prod'
            }
            steps {
               script {
                   echo "Deploying to prod server"
                   """
                   docker pull ${IMAGE_NAME}:${IMAGE_TAG}
                   docker run -d --name myapp-test -p 80:80 ${IMAGE_NAME}:${IMAGE_TAG}
                   """
               } 
            }
        }

        

        stage('Stop & Cleanup') {
            agent {
                    label 'test1'
                }
            steps {
                script {
                    echo "Stopping and removing test container..."
                    sh """
                        docker stop myapp-test || true
                        docker rm myapp-test || true
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Docker pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Cleaning up..."
            sh "docker rm -f myapp-test || true"
        }
    }
}
