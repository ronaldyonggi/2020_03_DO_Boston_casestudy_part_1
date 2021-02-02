pipeline {
    environment {
        registry = "ryongg/pipeline-app"
        registryCredential = 'dockerhub'
        dockerImage=''
    }
    stages{
        stage ('GitHub Checkout'){
            steps {
                git branch: 'main', url: 'https://github.com/ronaldyonggi/2020_03_DO_Boston_casestudy_part_1'
            }
        }

        stage ('Build docker image'){
            steps {
                script {
                    docker.build registry + ":$BUILD_NUMBER"
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
}