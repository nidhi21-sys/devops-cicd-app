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
               sh "trivy image ${IMAGE_NAME}:${IMAGE_TAG}"
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
                                           echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                        "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                        docker logout
                  }
     
       }
        }
       stage('Deploy') {
           steps {
             echo 'Deploying application...'
           }
     }
      stage('Verify') {
         steps {
            sh 'curl -f http://localost'
           }
        }
     }
  }

 

 
    
             
 
          
          

              
            
           
 
   
     

  
 
  
      
  
