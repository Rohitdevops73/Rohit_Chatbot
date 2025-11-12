pipeline{
    agent any
    environment{
        IMAGE_NAME = "rohitchatbot:${GIT_COMMIT}"
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
                   docker run -it -d --name ${IMAGE_NAME}_container -p 9001:8501 ${IMAGE_NAME}
                   '''
            }
        }

}
}