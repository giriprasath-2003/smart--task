pipeline {
    agent any
    
    tools {
      nodejs 'frontend'
    }
    
     environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        CLOUDFRONT_DIST_ID= 'E16ULL4FANY9XQ'
        AWS_CREDENTIALS= credentials('aws-id')
        }
    
    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'git-creds',
                    url: 'https://github.com/giriprasath-2003/smart--task.git'
            }
         }
  
         stage('Install') {
              steps { 
                  dir('frontend') {
                      sh 'npm ci'
                }
            }
         }
        
         stage('build') {
              steps {
                   dir('frontend') {
                       sh 'npm run build'
                   }     
                }
             }   
           
          stage('Sonarqube Analysis') {
            steps {
                script {
                    def scannerhome = tool name: 'sonarqube', type: 'hudson.plugins.sonar.SonarRunnerInstallation'

                withSonarQubeEnv('sonarqube') {    
                   withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                      sh """
                            ${scannerhome}/bin/sonar-scanner \
                            -Dsonar.projectKey=frontend \
                            -Dsonar.sources=frontend \
                            -Dsonar.host.url=http://localhost:9000 \
                            -Dsonar.login=${SONAR_TOKEN}
                            """
                 }
             }
         }
      }   
          stage('Quality Gate') {
              steps {
                  timeout(time: 5, unit: 'MINUTES') {
                      waitForQualityGate( abortPipeline: false, credentialsId: 'sonar-token')
             }
         }
     }

           stage('using Terraform'){
               steps{
                   echo 'Creating AWS Service by Terraform'
                   sh '''
                   cd Terraform
                   terraform init
                   terraform import aws_s3_bucket.s3 frontend-giri || true  
                   terraform plan
                   terraform apply -auto-approve
                   '''
                  echo 'Successfully Aws Services Created'
      }
    }
         stage('Terraform Outputs'){
             steps{
                 echo 'Mentioning terrafrom Variables...'
                  dir('Terraform') {
                  script {
                  env.S3_BUCKET= "frontend-giri"
                  env.CLOUDFRONT_DIST_ID= "E16ULL4FANY9XQ"
                  echo "S3_BUCKET= ${env.S3_BUCKET}"
                  echo "CLOUDFRONT_DIST_ID= ${env.CLOUDFRONT_DIST_ID}"
             }
         }
      }
    }
           stage('Deploy S3 Bucket'){
              steps{
                  echo 'updating S3 Bucket'
                  sh ''' 
                  aws s3 sync frontend/dist/ \
                  s3://${S3_BUCKET}/ \
                  --delete \
                  --region $AWS_DEFAULT_REGION
                  '''
                  echo 'Frontend Uploaded Successfully'
       }      
     }
        stage('Cloudfront Deployment'){
            steps{
                echo 'Deploying...'
                sh ''' 
                  aws cloudfront create-invalidation \
                  --distribution-id E16ULL4FANY9XQ \
                  --paths "/*"
                  '''
  
        }
     }
  }
} 
      
