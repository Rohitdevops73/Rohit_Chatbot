pipeline{
    agent any
    environment{
        IMAGE_NAME = "rohitkube/rohit_chatbot:${GIT_COMMIT}"
        AWS_REGION = "ap-south-1"
        CLUSTER_NAME = "rohitchatbot-eks-cluster"
        NAMESPACE = "chatbot"
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
        //stage('Testing-stage'){
        //    steps{
        //        sh '''
        //        echo "Running tests..."
        //           
        //           docker run -it -d --name chatbot${GIT_COMMIT} -p 9001:8501 ${IMAGE_NAME}
        //           '''
        //    }
        //}
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
        stage('Cluster-update'){
            steps{
                sh '''
                echo "Updating the EKS cluster..."
                aws eks update-kubeconfig --region ${AWS_REGION}  --name ${CLUSTER_NAME}
                '''
            }
        }
        stage('Deploy to EKS'){
            steps{
                withKubeConfig(caCertificate: '', clusterName: ' rohitchatbot-eks-cluster', contextName: '', credentialsId: 'kube', namespace: 'chatbot', restrictKubeConfigAccess: false, serverUrl: 'https://AC34E1B7B9F657A1F88959E715CB29AD.gr7.ap-south-1.eks.amazonaws.com') {
                    sh '''
                    sed -i 's|replace|${IMAGE_NAME}|g' Deployment.yaml
                    echo "Deploying to EKS..."
                    kubectl apply -f Deployment.yaml -n ${NAMESPACE}
                    '''
                }
            }
        }
        stage('Verify Deployment'){
            steps{
                withKubeConfig(caCertificate: '', clusterName: ' rohitchatbot-eks-cluster', contextName: '', credentialsId: 'kube', namespace: 'chatbot', restrictKubeConfigAccess: false, serverUrl: 'https://AC34E1B7B9F657A1F88959E715CB29AD.gr7.ap-south-1.eks.amazonaws.com') {
                sh '''
                kubectl get pods -n ${NAMESPACE}
                kubectl get svc -n ${NAMESPACE}
                '''
            }
        }
}
}