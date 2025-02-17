pipeline {
    agent any

    environment {
        // Define environment variables if needed
        MAVEN_HOME = tool name: 'Maven', type: 'Maven'  // Specify Maven installation
        JAVA_HOME = tool name: 'JDK 17', type: 'JDK'     // Specify JDK version
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout code from Git repository (Gitea, GitHub, etc.)
                git credentialsId: 'admin:efdc7a3d42284c87b9a03a031b32d146', url: 'http://gitea:3000/ci_cd.git'
            }
        }

        stage('Build') {
            steps {
                script {
                    // Use Maven to build the project (compiling the code)
                    // This could be changed to other build tools like Gradle
                    sh "'${MAVEN_HOME}/bin/mvn' clean install -DskipTests"
                }
            }
        }

        stage('Unit Test') {
            steps {
                script {
                    // Run unit tests with Maven (optional: skip if you want to run in a later stage)
                    sh "'${MAVEN_HOME}/bin/mvn' test"
                }
            }
        }

        stage('Static Code Analysis') {
            steps {
                script {
                    // Optional: Use SonarQube or any static code analysis tool to check code quality
                    // Example: Running SonarQube analysis
                    sh "'${MAVEN_HOME}/bin/mvn' sonar:sonar -Dsonar.host.url=http://sonarqube:9000"
                }
            }
        }

        stage('Integration Test') {
            steps {
                script {
                    // Run integration tests (assumes you have an integration-test phase in Maven)
                    // You can use Docker containers or other services for integration testing
                    sh "'${MAVEN_HOME}/bin/mvn' verify -DskipTests=false"
                }
            }
        }

        stage('Package') {
            steps {
                script {
                    // Package the application into a JAR, WAR, or Docker image
                    sh "'${MAVEN_HOME}/bin/mvn' package"
                }
            }
        }

        stage('Publish Artifacts') {
            steps {
                script {
                    // Push artifacts to Nexus or any artifact repository (optional)
                    // Example: Pushing a JAR to Nexus
                    sh "'${MAVEN_HOME}/bin/mvn' deploy"
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed, check the logs for details.'
        }
    }
}
