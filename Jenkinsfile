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
                
                   docker run -it -d --name rohit${GIT_COMMIT} -p 9004:8501 ${IMAGE_NAME}
                   '''
            }
        }
        
}
}