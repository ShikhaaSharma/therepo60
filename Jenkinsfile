pipeline {
    agent any
    environment {
        IMAGE_NAME = "shikha1818/laptoppipeline"
        DOCKER_REGISTRY = "docker.io"
        DOCKER_CRED = "docker-registry-credentials"
        SONAR_TOKEN = credentials('sonar-token')
        SSH_CRED = "dockerrun"
        DOCKER_TAG = "${env.BUILD_NUMBER ?: 'local'}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ShikhaaSharma/theproject50.git'
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn clean package -DskipTests=false'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                sh "mvn sonar:sonar -Dsonar.login=${SONAR_TOKEN}"
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: DOCKER_CRED,
                    usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                        sh "docker build -t ${IMAGE_NAME}:${DOCKER_TAG} ."
                        sh "docker push ${IMAGE_NAME}:${DOCKER_TAG}"
                        sh "docker tag ${IMAGE_NAME}:${DOCKER_TAG} ${IMAGE_NAME}:latest"
                        sh "docker push ${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Deploy to K8s via Ansible') {
            steps {
                sshagent([SSH_CRED]) {
                    sh "ssh -o StrictHostKeyChecking=no ec2-user@<ANSIBLE_CONTROL_NODE_IP> \
                        'cd /home/ec2-user/deploy && ansible-playbook -i inventory.ini playbook-deploy.yml'"
                }
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline executed successfully!'
        }
        failure {
            echo '❌ Pipeline failed. Check logs.'
        }
    }
}
