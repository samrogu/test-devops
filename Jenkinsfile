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
          ephemeral-storage: "2Gi"
        limits:
          memory: "1Gi"
          ephemeral-storage: "2Gi"
    - name: kaniko
      image: gcr.io/kaniko-project/executor:debug
      imagePullPolicy: Always
      command: ["tail", "-f", "/dev/null"]  
      imagePullPolicy: Always
      resources:
        requests:
          memory: "1Gi"
          cpu: "500m"
          ephemeral-storage: "1Gi"
        limits:
          memory: "1Gi"
          ephemeral-storage: "2Gi"
    - name: trivy
      image: aquasec/trivy:0.65.0
      imagePullPolicy: Always
      command: ["tail", "-f", "/dev/null"]  
      imagePullPolicy: Always
      resources:
        requests:
          memory: "1Gi"
          cpu: "500m"
          ephemeral-storage: "4Gi"
        limits:
          memory: "3Gi"
          ephemeral-storage: "4Gi"
'''
    defaultContainer 'maven'
        }
    }
    environment {
        DOCKER_REPO = 'us-central1-docker.pkg.dev/testdevops-470205/test-devops-repo/test-devops-java'
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
                        sh '/kaniko/executor --context `pwd` --dockerfile `pwd`/Dockerfile --destination=${DOCKER_REPO}:${BUILD_NUMBER} --cleanup'
                    }
                }
            }
        }
        stage('Vulnerability Scan - Docker Image'){
            steps{
                container('trivy'){
                    sh 'trivy image --severity HIGH,CRITICAL --exit-code 1 --no-progress ${DOCKER_REPO}:${BUILD_NUMBER}'
                }
            }
        }
    }
}