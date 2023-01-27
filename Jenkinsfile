pipeline {
    agent any
    stages {
        stage('1 - Build') {
            steps {
                echo "Build"
                sh '''
                date
                echo $BUILD_ID
                '''
            }
        }

        stage('Code Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM', 
                    branches: [[name: '*/main']], 
                    userRemoteConfigs: [[url: 'https://github.com/victoriiastee/Hometask9-Jenkins.git']]
                ])
            }
        }

        stage('Test') {
            steps {
                echo "Test"
            }
        }
        
        stage('Deploy') {
            steps {
                echo "Deploy"
            }
        }
        
        stage('Stage only for test branch') {
            when {
                expression { return env.BRANCH_NAME == 'test' }
            }
            steps {
                echo "This steps only for test stage!"
                echo "Result: SUCCESS"
            }
        } 
        post {
            always {
                emailext body: 'A Test EMail', recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: 'Test'
            }
        }
    }
}
