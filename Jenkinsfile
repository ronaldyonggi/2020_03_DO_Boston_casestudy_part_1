pipeline {
    environment {
        registry = "ryongg/msdmfs0535042"
        registryCredential = 'dockerhub'
        dockerImage = ''
    }
    agent any
    stages {
        stage ('Build docker image'){
            steps {
                script {
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
            }
        }
        stage ('Push image to Docker Hub'){
            steps {
                script {
                    docker.withRegistry( '', registryCredential) {
                        dockerImage.push()
                    }
                }
            }
        }
        stage ('Remove unused image'){
            steps {
                sh "docker rmi $registry:$BUILD_NUMBER"
            }
        }
    }
}