pipeline {
    agent any

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

        stage('Test'){
            agent {
                docker {
                    image 'node:18.20.4-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    test -f ./build/index.html
                    npm test
                '''

            }
        }
    }


}
