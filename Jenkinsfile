pipeline {
    agent any

    environment {
        IMAGE_NAME = 'nidhi460/devops-app'
        IMAGE_TAG  = "build-${BUILD_NUMBER}"
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
                echo 'Building application...'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                sh '''
                test -f index.html
                echo "Test Passed"
                '''
            }
        }

        stage('Security Check') {
            steps {
                echo 'Checking application security...'

                sh '''
                if [ ! -f Dockerfile ]; then
                    echo "Dockerfile Missing"
                    exit 1
                fi

                echo "Dockerfile Found"
                '''
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Building Docker Image...'

                sh '''
                docker build \
                -t ${IMAGE_NAME}:${IMAGE_TAG} \
                -t ${IMAGE_NAME}:latest .
                '''
            }
        }

        stage('Docker Image Scan') {
            steps {
                echo 'Scanning Docker Image using Trivy...'

                sh '''
                trivy image \
                --severity HIGH,CRITICAL \
                --exit-code 1 \
                ${IMAGE_NAME}:${IMAGE_TAG}
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
                    echo "$DOCKER_PASSWORD" | docker login \
                    -u "$DOCKER_USERNAME" \
                    --password-stdin

                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    docker push ${IMAGE_NAME}:latest

                    docker logout
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying Container...'

                sh '''
                docker rm -f devops-app || true

                docker run -d \
                --name devops-app \
                -p 80:80 \
                ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                echo 'Verifying application health...'

                sh '''
                sleep 10
                curl -f http://localhost || exit 1
                '''
            }
        }
    }

    post {

        success {
            echo 'Pipeline Completed Successfully'
        }

        failure {
            echo 'Pipeline Failed'
        }

        always {
            echo 'Production Readiness Pipeline Finished'
        }
    }
}
 

 
    
             
 
          
          

              
            
           
 
   
     

  
 
  
      
  
