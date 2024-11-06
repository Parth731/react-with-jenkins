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

        stage('Test'){
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
        }

         stage('E2E'){
            agent {
                docker {
                    image 'mcr.microsoft.com/playwright:v1.48.1-noble'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    npm install serve
                    node_modules/.bin/serve -s build &
                    sleep 10
                    npm test:e2e
                '''

            }
        }

        // post {
        //     always {
        //         junit 'test-results/junit.xml'
        //     }
        // }
    }


}
