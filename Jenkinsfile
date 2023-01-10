pipeline {
    agent any
    environment {
        image_name="076325154541.dkr.ecr.eu-central-1.amazonaws.com/flask_final"
    }
    stages {
        stage('Build') {
            steps {
              sh '''
                docker build -t "${image_name}:$GIT_COMMIT" .
              '''
            }
        }
        stage('Test') {
            steps {
              sh '''
                docker run -dit --name dreme -p 5000:5000 "${image_name}:$GIT_COMMIT"
                sleep 10
                curl localhost:5000
                exit_status=$?
                if [[ $exit_status == 0 ]]
                then echo "SUCCESSFUL TESTS" && docker stop dreme && docker rm dreme
                else echo "FAILED TESTS" && docker stop $(docker ps -q) && exit 1
                fi
               '''
            }
        }
        stage('Push') {
            steps {
               sh '''
                  docker login -u AWS https://076325154541.dkr.ecr.eu-central-1.amazonaws.com -p $(aws ecr get-login-password --region eu-central-1)
                  docker push ${image_name}:$GIT_COMMIT
                '''
            }
        }
        stage("Deploy") {
            steps {
                sh '''
                    helm install --debug --atomic flask helm/ --wait --namespace dev --create-namespace --set deployment.tag=$GIT_COMMIT --set deployment.env=dev
                '''
          }
        }
       
       }
    }
