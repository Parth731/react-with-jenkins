pipeline {
    agent any

    environment {
        NETLIFY_SITE_ID = '0f6bdba2-8c00-4ccf-bcfa-91796c683f26'
        NETLIFY_AUTH_TOKEN = credentials('netlify-token')
    }

    stages {

     
    
        stage('Build') {
            agent {
                docker {
                    image 'node:18.20.4-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    ls -la
                    node --version
                    npm --version
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
                            image 'mcr.microsoft.com/playwright:v1.48.1-noble'
                            reuseNode true
                            args '-u root:root'
                        }
                    }
                    steps {
                        sh '''
                            npm install -g serve
                            nohup serve -s build &
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

        stage('') {

         
            agent {
                docker {
                    image 'node:18.20.4-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                
                '''
                script{
                    env.STAGING_URL = sh(script:"node_modules/.bin/node-jq -r '.deploy_url' deploy-output.json",returnStdout: true).trim()
                }
            }
           
        }

        stage('Deploy Staging'){
  
            agent {
                docker {
                    image 'mcr.microsoft.com/playwright:v1.48.1-noble'
                    reuseNode true
                    args '-u root:root'
                }
            }
                environment {
                    CI_ENVIRONMENT_URL = 'STAGING_URL_TO_BE_SET'
            }
            steps {
                sh '''
                npm install netlify-cli
                npm install node-jq
                node_modules/.bin/netlify --version
                echo "Deploying to staging with netlify. Site ID: $NETLIFY_SITE_ID"
                node_modules/.bin/netlify status
                node_modules/.bin/netlify deploy --dir=build --json > deploy-output.json
                CI_ENVIRONMENT_URL=$(node_modules/.bin/node-jq -r '.deploy_url' deploy-output.json)
                npx playwright test --reporter=html   
                '''
            }

            post {
                always {
                    publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Staging E2E', reportTitles: '',   
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
                    image 'mcr.microsoft.com/playwright:v1.48.1-noble'
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
                npm install netlify-cli
                node_modules/.bin/netlify --version
                echo "Deploying to production with netlify. Site ID: $NETLIFY_SITE_ID"
                node_modules/.bin/netlify status
                node_modules/.bin/netlify deploy --dir=build --prod --json 
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
