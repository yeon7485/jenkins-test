pipeline {
    agent any

    environment {
        IMAGE_NAME = 'seyeonni/backend'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Git Clone') {
            steps {
                echo "Clone Repository"
                git branch: 'main', url: 'https://github.com/yeon7485/jenkins-test'
            }
        }

        stage('Gradle Build') {
            steps {
                echo "Add Permission"
                sh 'chmod +x gradlew'

                echo "Build"
                sh './gradlew bootJar'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push to Registry') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'DOCKER_HUB']) {
                        docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push()
                    }
                }
            }
        }

        stage('SSH Deploy') {
            steps {
                script {
                    sshPublisher(
                        publishers: [
                            sshPublisherDesc(
                                configName: 'k8s',
                                verbose: true,
                                transfers: [
                                    sshTransfer(
                                        sourceFiles: 'k8s/backend-deployment.yml',
                                        remoteDirectory: '/',
                                        execCommand: '''
                                            sed -i "s/latest/${BUILD_NUMBER}/g" /home/test/k8s/backend-deployment.yml
                                        '''
                                    ),
                                    sshTransfer(
                                        execCommand: '''
                                            kubectl apply -f /home/test/k8s/backend-deployment.yml
                                        '''
                                    )
                                ]
                            )
                        ]
                    )
                }
            }
        }
    }
}
