pipeline {

    agent any

    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/vinod1188/cicd-python-todo-app.git'
            }
        }

        stage('build docker') {
            steps {
                script {
                    sh 'echo Build Docker Image'
                    sh 'docker build -t vinod1188/python-jenkins-argocd-k8s:${BUILD_NUMBER} .'
                }
            }
        }

        stage('push artifacts') {
            steps {
                script {
                    sh 'echo push the docker image'
                    sh 'docker push vinod1188/python-jenkins-argocd-k8s:${BUILD_NUMBER}'
                    def dockerImage = docker.image("vinod1188/python-jenkins-argocd-k8s:${BUILD_NUMBER}")
                    docker.withRegistry('https://index.docker.io/v1/', "docker-creds") {
                        dockerImage.push("${BUILD_NUMBER}")
                    }
                }
            }
        }

        stage('update k8 manifest file and push') {
            steps {
                withCredentials([string(credentialsId: 'githubID', variable: 'GITHUB_TOKEN')]) {
                    sh '''
                        git config user.email "vinod118888@gmail.com"
                        git config user.name "vinod1188"
                        sed -i "s/replaceImageTag/${BUILD_NUMBER}/g":${BUILD_NUMBER}|g" deploy/deploy.yml
                        git add deploy/deploy.yml
                        git commit -m "Update deployment image to version ${BUILD_NUMBER}"
                        git push https://${GITHUB_TOKEN}@github.com/vinod1188/cicd-python-todo-app HEAD:main
                    '''
                }
            }
        }
    }
}
