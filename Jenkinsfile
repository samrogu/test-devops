pipeline{
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  serviceAccount: jenkins-wi-gke-test-1
  containers:
    - name: build
      image: samrogu/build-tools-devops:v1.0.0
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
    defaultContainer 'build'
        }
    }
    parameters {
        string(name: 'PROJECTID', defaultValue: 'testdevops-470205', description: 'PROJECTID')
        string(name: 'REGION', defaultValue: 'us-central1', description: 'REGION')
    }
    environment {
        DOCKER_REPO = 'us-central1-docker.pkg.dev/testdevops-470205/test-devops-repo/test-devops-java'
    }
    stages{
        stage('Git Checkout'){
            steps{
                git branch: 'feature/deployapp', url: 'https://github.com/samrogu/test-devops.git'
            }
        }
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
        stage('Code Analysis - SonarQube'){
            environment {
                SCANNER_HOME = tool 'SonarScanner'
                ORGIN_BRANCH = 'feature/deployapp'
            }
            steps{
                dir('demo-devops-java'){
                    withSonarQubeEnv('SonarServerTest'){
                        sh '''${SCANNER_HOME}/bin/sonar-scanner \
                        -Dsonar.organization=devops-testdevsu \
                        -Dsonar.projectKey=test-devops-java \
                        -Dsonar.projectName="test-devops-java" \
                        -Dsonar.projectVersion=${BUILD_NUMBER} \
                        -Dsonar.sources=src \
                        -Dsonar.java.binaries=target/classes \
                        -Dsonar.sourceEncoding=UTF-8
                        '''
                    }
                }
            }
        }
        stage('Vulnerability Scan - Docker Image'){
            steps{
                container('trivy'){
                    // trivy image --severity HIGH,CRITICAL --exit-code 1 --no-progress ${DOCKER_REPO}:${BUILD_NUMBER}
                    sh '''
                    trivy image --severity HIGH,CRITICAL \
                    --format template \
                    --template "@/contrib/html.tpl" \
                    --output trivy-report.html \
                    ${DOCKER_REPO}:${BUILD_NUMBER}
                    '''
                }
            }
        }
        stage('Deploy to GKE'){
            steps{
                sh "gcloud container clusters get-credentials gke-test-1 --project ${PROJECTID} --zone ${REGION}"
                script {
                    def namespace = ''
                    def domainapp = ''
                    if (env.BRANCH_NAME ==~ /PR-.*/) {
                        error("This is a PR branch. Deployment is not allowed.")
                    } else if (env.BRANCH_NAME == 'main') {
                        domainapp = 'devsuprod'
                        namespace = 'production'
                    } else if (env.BRANCH_NAME == 'qa') {
                        namespace = 'qa'
                    } else if (env.BRANCH_NAME == 'dev') {
                        domainapp = 'devsutest'
                        namespace = 'development'
                    }
                    sh "sed -i 's/appdomain/'${domainapp}'/g' k8s-app/values.yaml"
                    sh "helm upgrade --install test-devops ./k8s-app --set image.tag=${BUILD_NUMBER} --namespace=${namespace} --wait"
                }
            }
        }
    }
    post {
        always {
            archiveArtifacts artifacts: 'trivy-report.html', fingerprint: true
            junit 'demo-devops-java/target/surefire-reports/*.xml'
        }
    }
}