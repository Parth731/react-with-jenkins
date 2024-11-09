pipeline {
    agent any

    environment {
        REACT_APP_VERSION = "1.0.$BUILD_ID"
        AWS_DEFAULT_REGION = 'ap-south-1'
    }

  

    stages {

        stage('Deploy to AWS'){
            agent {
                docker {
                    image 'amazon/aws-cli'
                    reuseNode true
                    args '--entrypoint=""'
                }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'my-aws',              passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                    // some block
                    sh '''
                    aws --version
                    aws ecs register-task-definition --cli-input-json file://aws/task-defination-prod.json
                    '''
                }
            }
        }   

        stage('Build') {
            agent {
                docker {
                    image 'node:18.20.4-alpine'
                    reuseNode true
                    args '-u root:root'
                }
            }
            steps {
                sh '''
                    ls -la
                    node --version
                    npm --version
                    # npm install
                    npm ci
                    npm run build
                    npm test
                    ls -la
                '''
            }
        }
    


    

      
    }
   

}
