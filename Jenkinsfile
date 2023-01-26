pipeline {
    agent any
    environment {
        PROJECT_ID = 'faby-375009'
        CLUSTER_NAME = 'cluster-1'
        LOCATION = 'us-central1-a'
        CREDENTIALS_ID = 'kubernetes'	
    }
    stages {
        stage("Checkout code") {
            steps {
                checkout scm
            }
        }
        stage('Build Docker Image') {
		    steps {
			    sh 'whoami'
			    script {
				    myimage = docker.build("fabien123/jenkins_project:${env.BUILD_ID}")
			    }
		    }
	    }
	    
	    stage("Push Docker Image") {
		    steps {
			    script {
				    echo "Push Docker Image"
				    withCredentials([string(credentialsId: 'dockerhub', variable: 'dockerhub')]) {
            				sh "docker login -u fabien123 -p ${dockerhub}"
				    }
				        myimage.push("${env.BUILD_ID}")
				    
			    }
		    }
	    }
        stage('Deploy to GKE') {
            steps{
                sh "sed -i 's/jenkins_project:latest/jenkins_project:${env.BUILD_ID}/g' deployment.yaml"
                step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'deployment.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
            }
        }
    }
}