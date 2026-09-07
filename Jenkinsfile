pipeline {
   
    agent any
    
    environment {
       IMAGE_NAME = 'nidhi460/jenkins-demo'
       IMAGE_TAG = "build-${BUILD_NUMBER}"
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
            sh 'ls -la'
       }
  }
 
       stage('Test') {
         steps {
            echo 'Running automated tests...'
            sh './test.sh'

       }
  }

      stage('Package') {
         steps {
            echo 'Packaging Application...'
            sh 'tar -czf website-${BUILD_NUMBER}.tar.gz index.html Dockerfile'
      }
  }
    
      stage('Docker Build') {
          steps {
             echo 'Building Docker Image...'
             sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG}'
      }
  }

      stage('Docker Push') {
          steps {
             echo 'Pushing Docker image to Docker Hub...'
 
             withCredentials([
               usernamePassword(
               credentialsId: 'dockerhub-credentials',
               usernameVariable: 'nidhi460',
               passwordVariable: 'nidhi@1234'
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
 }
     
 post {
    success {
        echo 'Pipeline completed successfully!'
      }

    failure {
        echo 'Pipeline failed!'
      }
    }
 }




    









           

        
