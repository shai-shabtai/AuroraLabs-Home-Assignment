pipeline {
    agent any

    parameters {
        string(name: 'BRANCH_NAME', description: 'Enter the name of the branch to build', defaultValue: 'main')
        string(name: 'GITHUB_URL', description: 'Enter the GITHUB URL', defaultValue: 'https://github.com/shai-shabtai/AuroraLabs-Home-Assignment.git')
    }
    triggers {
        githubPush()
    }

    stages {
        stage('GitHub Checkout') {
            steps {
                    checkout([$class: 'GitSCM', branches: [[name: "${params.BRANCH_NAME}"]], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: "${params.GITHUB_URL}"]]])

            }
        }

        stage('Build') {
            steps {
    	            dir('python_app/') {
                	      sh "docker build -f Dockerfile -t py-aurora-app:${params.BRANCH_NAME} ."
		            }
            }
        }

        stage('Run') {
            steps {
                    sh "docker run -d -p 5000:5000 --name py-app-check py-aurora-app:${params.BRANCH_NAME}"
            }
        }
		
        stage('Test') {
            steps {
		            sleep time: 5, unit: 'SECONDS'
                    sh "bash test.sh"       
            }
        }  
        stage('Docker-Login, Tag and Push') {
	        steps {
			    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKERHUB_CREDENTIALS_USR', passwordVariable: 'DOCKERHUB_CREDENTIALS_PSW')]) {
          		    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
			    	sh 'docker tag py-aurora-app:main $DOCKERHUB_CREDENTIALS_USR/py-aurora-app:latest'
		            sh 'docker push $DOCKERHUB_CREDENTIALS_USR/py-aurora-app:latest'
			    }
			}	
		}
	    
        stage('Deploy') {
	        steps {
		            sh "bash deploy.sh"
	        }
        }
    }
	post {
        always {
                sh "docker stop count-service-check"
            	sh "docker rm count-service-check"
        }
    }
}