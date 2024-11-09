pipeline {
    agent any

    environment {
        NETLIFY_SITE_ID = '0f6bdba2-8c00-4ccf-bcfa-91796c683f26'
        NETLIFY_AUTH_TOKEN = credentials('netlify-token')
        REACT_APP_VERSION = "1.0.$BUILD_ID"
    }

  

    stages {

        stage('AWS'){
            agent {
                docker {
                    image 'amazon/aws-cli'
                    args '--entrypoint=""'
                }
            }
            environment {
                AWS_S3_BUCKET = 'learn-jenkins-11920240605'
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'my-aws',              passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                    // some block
                    sh '''
                    aws --version
                    aws s3 ls
                    echo "Deploying to AWS $AWS_SECRET_ACCESS_KEY"
                    echo "Hello S3 !" > index.html
                    aws s3 cp index.html s3://$AWS_S3_BUCKET/index.html 
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
    

        stage('Tests'){
            parallel {
                stage('Unit Test'){
                    agent {
                        docker {
                            image 'node:18.20.4-alpine'
                            reuseNode true
                            args '-u root:root'
                        }
                    }
                    steps {
                        sh '''
                            # test -f ./build/index.html
                            npm test
                        '''

                    }

                    //  post {
                    //     always {
                    //         // junit 'jest-results/junit.xml
                    //     }
                    // }	
                }

                stage('E2E'){
                    
                    agent {
                        docker {
                            image 'my-playwright'
                            reuseNode true
                            args '-u root:root'
                        }
                    }
                    steps {
                        sh '''
                            serve -s build &
                            sleep 15
                            # npx playwright install
                            npx playwright test --reporter=html   
                        '''

                    }

                    post {
                        always {
                             publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Playwright Local', reportTitles: '', useWrapperFileDirectly: true])

                          
                        }
                    }	
                }
            }
        }

        stage('Deploy Staging'){
  
            agent {
                docker {
                    image 'my-playwright'
                    reuseNode true
                    args '-u root:root'
                }
            }
                environment {
                    CI_ENVIRONMENT_URL = 'STAGING_URL_TO_BE_SET'
            }
            steps {
                sh '''
                netlify --version
                echo "Deploying to staging with netlify. Site ID: $NETLIFY_SITE_ID"
                netlify status
                netlify deploy --dir=build --json > deploy-output.json
                CI_ENVIRONMENT_URL=$(jq -r '.deploy_url' deploy-output.json)
                npx playwright test --reporter=html   
                '''
            }

            post {
                always {
                    publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Staging E2E', reportTitles: '', useWrapperFileDirectly: true]) 
                }
            }	
        }

        stage('Approval') {
            steps {
                timeout(time:15, unit:'MINUTES') {
                   input message: 'Do you wish to deploy to production?', ok: 'Yes, I am sure!'
                }
               
            }
        }

        stage('Deploy Prod'){
            agent {
                docker {
                    image 'my-playwright'
                    reuseNode true
                    args '-u root:root'
                }
            }
            environment {
                CI_ENVIRONMENT_URL = 'https://tranquil-halva-ef2997.netlify.app'
            }
            steps {
                sh '''
                node --version
                netlify --version
                echo "Deploying to production with netlify. Site ID: $NETLIFY_SITE_ID"
                netlify status
                netlify deploy --dir=build --prod --json 
                npx playwright test --reporter=html   
                '''

            }

            post {
                always {
                        publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Prod E2E', reportTitles: '', useWrapperFileDirectly: true])

                    
                }
            }	
        }

      
    }
   

}
