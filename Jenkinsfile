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
                            publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Playwright HTML Report', reportTitles: '', useWrapperFileDirectly: true])
                        }
                    }	
                }
            }
        }

        stage('Deploy') {
        agent {
            docker {
                image 'node:18.20.4-alpine'
                reuseNode true
            }
        }
        steps {
            sh '''
               npm install netlify-cli
               node_modules/.bin/netlify --version
               echo "Deploying to production with netlify. Site ID: $NETLIFY_SITE_ID"
               node_modules/.bin/netlify status
            '''
        }
        }

      
    }
   

}
