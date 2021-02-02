pipeline {
    agent any
    stages{
        stage ('SCM Checkout'){
            steps {
                git branch: 'main', url: 'https://github.com/ronaldyonggi/2020_03_DO_Boston_casestudy_part_1'
            }
        }

        stage ('Retrieve authentication token and authenticate Docker registry'){
            steps {
                sh 'aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/t2e6o6l2'
            }
        }

    }
}