pipeline {
    agent any

    stages {
        /*
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
        */

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

      
    }
   

}
