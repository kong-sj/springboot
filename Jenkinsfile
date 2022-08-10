pipeline {
  agent any
  tools {
    maven 'm3'
  }

  environment {
      dockerHubRegistry = 'sjhong1994/k8s-lab'
      /* dockerHubRegistryCredential = '{Credential ID}'*/
  }

  stages {

    stage('Checkout Application Git Branch') {
        steps {
            git credentialsId: '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',
                url: 'https://github.com/kong-sj/springboot.git',
                branch: 'main'
        }
        post {
                failure {
                  echo 'Repository clone failure !'
                }
                success {
                  echo 'Repository clone success !'
                }
        }
    }


    stage('Maven Jar Build') {
            steps {
                sh 'chmod +x mvnw'
                sh './mvnw install'
            }
            post {
                    failure {
                      echo 'Maven jar build failure !'
                    }
                    success {
                      echo 'Maven jar build success !'
                    }
            }

    }

    stage('Docker Image Build') {
            steps {
                sh "cp target/hello-spring-0.0.1-SNAPSHOT.jar ./ROOT.jar"
                sh "docker build . -t ${dockerHubRegistry}:${currentBuild.number}"
                sh "docker build . -t ${dockerHubRegistry}:latest"
            }
            post {
                    failure {
                      echo 'Docker image build failure !'
                    }
                    success {
                      echo 'Docker image build success !'
                    }
            }
    }


    stage('Docker Image Push') {
            steps {
                      sh "echo tjdwns12* | docker login -u sjhong1994 --password-stdin"
                      sh "docker push ${dockerHubRegistry}:${currentBuild.number}"
                      sh "docker push ${dockerHubRegistry}:latest"
                      sleep 10 /* Wait uploading */
                  
            }
            post {
                    failure {
                      echo 'Docker Image Push failure !'
                      sh "docker rmi ${dockerHubRegistry}:${currentBuild.number}"
                      sh "docker rmi ${dockerHubRegistry}:latest"
                    }
                    success {
                      echo 'Docker image push success !'
                      sh "docker rmi ${dockerHubRegistry}:${currentBuild.number}"
                      sh "docker rmi ${dockerHubRegistry}:latest"
                    }
            }
    }
    
    stage('K8S Manifest Update') {
        steps {
            git credentialsId: 'jenkins',
                url: 'https://github.com/kong-sj/manifest.git',
                branch: 'main'

            sh "sed -i 's/my-app:.*\$/my-app:${currentBuild.number}/g' deployment.yaml"
            sh "git add deployment.yaml"
            sh "git commit -m '[UPDATE] my-app ${currentBuild.number} image versioning'"
            sshagent(credentials: ['{k8s-manifest repository credential ID}']) {
                sh "git remote set-url origin git@github.com:best-branch/k8s-manifest.git"
                sh "git push -u origin master"
             }
        }
        post {
                failure {
                  echo 'K8S Manifest Update failure !'
                }
                success {
                  echo 'K8S Manifest Update success !'
                }
        }
    }

  }
}
