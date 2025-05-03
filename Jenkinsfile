pipeline {
    agent {
        docker {
            image 'docker:latest'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    tools {
        maven "Maven"
    }

    environment {
        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_URL = "nexus:8081"
        NEXUS_REPOSITORY = "maven-snapshots"
        NEXUS_CREDENTIAL_ID = "9248e92a-dba9-491c-849b-472e3d3ca7fa"
    }

    stages {
        stage('Hello') {
            steps {
                echo 'Hello'
            }
        }

        stage('Clone Code') {
            steps {
                git branch: 'main',
                credentialsId: 'a9499c5c-d4ec-4267-b131-363495a49924',
                url: 'http://gitea:3000/admin/ci_cd.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('Package') {
            steps {
                sh 'mvn package -DskipTests=true'
            }
        }

        stage('Publish to Nexus') {
            steps {
                script {
                    pom = readMavenPom file: 'pom.xml'
                    artifact = findFiles(glob: "target/*.${pom.packaging}")[0]

                    if (fileExists(artifact.path)) {
                        nexusArtifactUploader(
                            nexusVersion: NEXUS_VERSION,
                            protocol: NEXUS_PROTOCOL,
                            nexusUrl: NEXUS_URL,
                            groupId: pom.groupId,
                            version: pom.version,
                            repository: NEXUS_REPOSITORY,
                            credentialsId: NEXUS_CREDENTIAL_ID,
                            artifacts: [
                                [artifactId: pom.artifactId, file: artifact.path, type: pom.packaging],
                                [artifactId: pom.artifactId, file: 'pom.xml', type: 'pom']
                            ]
                        )
                    } else {
                        error "Artifact not found: ${artifact.path}"
                    }
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'dockerhub_credentials', url: 'https://index.docker.io/v1/') {
                        sh 'docker build -t bojjana/my-image:latest .'
                        sh 'docker push bojjana/my-image:latest'
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check the logs for details.'
        }
    }
}