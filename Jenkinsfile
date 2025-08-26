pipeline{
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
    - name: maven
      image: maven:3.9.11-eclipse-temurin-21
      command: ["tail", "-f", "/dev/null"]  
      imagePullPolicy: Always
      resources:
        requests:
          memory: "1Gi"
          cpu: "500m"
        limits:
          memory: "1Gi"
'''
    defaultContainer 'maven'
        }
    }
    stages{
        stage('Build'){
            steps{
                dir('demo-devops-java'){
                    sh 'mvn clean package -DskipTests'
                }
            }
        }
        stage('Test'){
            steps{
                dir('demo-devops-java'){
                    sh 'mvn test'
                }
            }
        }
        stage('Docker Build & Push'){
            steps{
                script{
                    dockerImage = docker.build("saguro/devsu-demo-devops-java:${env.BUILD_ID}")
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials'){
                        dockerImage.push()
                    }
                }
            }
        }
    }
}