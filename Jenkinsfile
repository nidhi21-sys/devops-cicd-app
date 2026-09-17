pipeline {

    agent any

    environment {
        IMAGE_NAME = 'nidhi460/devops-app'
        IMAGE_TAG  = "build-${BUILD_NUMBER}"
        CONTAINER_NAME = 'devops-app'
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Building Application...'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'test -f index.html'
            }
        }

        stage('Security Check') {
            steps {
                echo 'Performing basic security check...'
                sh 'test -f Dockerfile'
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                '''
            }
        }

        stage('Docker Image Scan') {
            steps {
                sh '''
                    trivy image ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                        docker logout
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    docker rm -f ${CONTAINER_NAME} 2>/dev/null || true

                    docker run -d \
                        --name ${CONTAINER_NAME} \
                        -p 8080:80 \
                        ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }

        stage('Verify') {
            steps {
                sh '''
                    sleep 5
                    curl -f http://localhost:8080
                '''
            }
        }
    }
}
