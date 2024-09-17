pipeline {
    
    agent any 
    
    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        
        stage('Checkout'){
           steps { 
                url: 'https://github.com/vinod1188/cicd-python-todo-app.git',
                branch: 'main'
           }
        }

        stage('Build Docker'){
            steps{
                script{
                    sh '''
                    echo 'Buid Docker Image'
                    docker build -t vinod1188/python-jenkins-argocd-k8s:${BUILD_NUMBER} .
                    '''
                }
            }
        }

        stage('Push the artifacts'){
           steps{
                script{
                    sh '''
                    echo 'Push to Repo'
                    docker push vinod1188/python-jenkins-argocd-k8s:${BUILD_NUMBER}
                    EGISTRY_CREDENTIALS = credentials('docker-cred')
                    '''
                }
            }
        }
        
         stage('Update Deployment File') {
        environment {
            GIT_REPO_NAME = "python-jenkins-argocd-k8s"
            GIT_USER_NAME = "vinod1188"
        }
        
        stage('Update K8S manifest & push to Repo'){
            steps {
                script{
                    withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) { 
                        sh '''
                        cat deploy.yaml
                        sed -i '' "s/vinod1188/python-jenkins-argocd-k8s/${BUILD_NUMBER}/g" python-jenkins-argocd-k8s/deploydeploy.yaml
                        cat deploy.yaml
                        git add deploy.yaml
                        git commit -m 'Updated the deploy.yaml | Jenkins Pipeline'
                        git remote -v
                        git push https://${GITHUB_TOKEN}@https://github.com/vinod1188/cicd-python-todo-app.git/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main
                        '''
                                                
                    }
                }
            }
        }
    }
}
