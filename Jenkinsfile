pipeline {
    agent {
        label 'test1'
    }

    triggers {
        githubPush()
    }

    environment {
        IMAGE_NAME = "raichu08/myapp"
        IMAGE_TAG = "v${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "Fetching latest code from GitHub..."
                checkout scm
            }
        }

        stage('Build Docker Image') {
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
            steps {
                script {
                    echo "Running container for testing..."
                    sh """
                        docker run -d --name myapp-test -p 8080:8080 ${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }

        stage('Test Docker Container') {
            steps {
                script {
                    echo "Testing container health..."
                    // Example test: check if container is running
                    sh """
                        sleep 5
                        docker ps | grep myapp-test
                    """
                }
            }
        }

        stage('Push to Dockerhub'){
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
                         """
                    }
                }
            }
        }

        stage('Docker Logout') {
            steps {
                script {
                    echo "logout from Docker"
                    sh """
                        docker logout
                    """
                }
            }
        }

        stage('Stop & Cleanup') {
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
