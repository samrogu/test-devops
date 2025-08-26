pipeline{
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  serviceAccount: jenkins-wi-gke-test-1
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
    - name: kaniko
      image: gcr.io/kaniko-project/executor:debug
      imagePullPolicy: Always
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
        stage('Build and Push Docker Image'){
            steps{
                dir('demo-devops-java'){
                    container('kaniko'){
                        sh '/kaniko/executor --context `pwd` --dockerfile `pwd`/Dockerfile --destination=gcr.io/testdevops-470205/test-devops-java:latest --destination=gcr.io/testdevops-470205/test-devops-java:${BUILD_NUMBER} --cleanup'
                    }
                }
            }
        }
    }
}
