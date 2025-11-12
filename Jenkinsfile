pipeline{
    agent any
    environment{
        IMAGE_NAME = "rohitkube/chatbot:${GIT_COMMIT}"
    }
    
    stages{
        stage('Git-checkout'){
           steps{
                git url: 'https://github.com/Rohitdevops73/Rohit_Chatbot.git'  ,branch: 'main' 
           }
        }
        stage('Build'){
            steps{
                echo 'Building the application...'
                sh '''
                docker build -t ${IMAGE_NAME} .
                '''
                // Add build commands here
            }
        }
        stage('Testing-stage'){
            steps{
                sh '''
                echo "Running tests..."
                   docker kill rohitchat-bot 
                   docker rm rohitchat-bot
                   docker run -it -d --name rohitchat-bot -p 9001:8501 ${IMAGE_NAME}
                   '''
            }
        }
        stage('Login to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        // Login to Docker Hub
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                    }
                }
            }
        }
        stage('Push to Docker Hub'){
            steps{
                sh '''
                echo "Pushing image to Docker Hub..."
                docker push ${IMAGE_NAME}
                '''
            }
        }
}
}