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
                   docker run -it -d --name rohit-chatbot1 -p 9001:8501 ${IMAGE_NAME}
                   '''
            }
        }
        stage('testing'){
            steps{
                sh '''
                echo "Testing the application..."
                sleep 20
                curl -f http://localhost:9001 || exit 1
                '''
            }
        }

}
}