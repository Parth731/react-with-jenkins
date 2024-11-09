pipeline {
    agent any

    environment {
        REACT_APP_VERSION = "1.0.$BUILD_ID"
        AWS_DEFAULT_REGION = 'ap-south-1'
        AWS_ECS_CLUSTER = 'LearnJekinsApp-Cluster-Prod'
        AWS_ECS_SERVICE_PROD = 'LearnJenkinsApp-Service-Prod'
        AWS_ECS_TD_PROD = 'LearnJenkinsApp-New-TaskDefinition-Prod'
        
    }

  

    stages {

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

        stage('Build Docker image'){
            agent {
                docker {
                    image 'amazon/aws-cli'
                    reuseNode true
                    // can not connect to the docker demon at unix ///var/run/docker.sock. Is the docker daemon running on this host? that error slove
                    args '-u root -v /var/run/docker.sock:/var/run/docker.sock --entrypoint=""'
                }
            }
            steps{
                sh '''
                    amazon-linux-extras install docker
                    docker build -t myjenkinsapp .
                '''
            }
        }

        stage('Deploy to AWS'){
            agent {
                docker {
                    image 'amazon/aws-cli'
                    reuseNode true
                    args '-u root --entrypoint=""'
                }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'my-aws',              passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                    // some block
                    sh '''
                    aws --version
                    yum install jq -y
                    LATEST_TD_REVISION=$(aws ecs register-task-definition --cli-input-json file://aws/task-defination-prod.json | jq '.taskDefinition.revision')

                    echo $LATEST_TD_REVISION
                    
                    aws ecs update-service --cluster $AWS_ECS_CLUSTER --service $AWS_ECS_SERVICE_PROD --task-definition $AWS_ECS_TD_PROD:$LATEST_TD_REVISION
                    
                    aws ecs wait services-stable --cluster $AWS_ECS_CLUSTER --services $AWS_ECS_SERVICE_PROD
                    '''
                }
            }
        }  

    }
   

}
