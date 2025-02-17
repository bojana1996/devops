pipeline {
  agent any
  tools {
    maven Maven
  }

  environment {
    NEXUS_URL = 'http://nexus:8081'
    NEXUS_REPO = 'maven-public'
    NEXUS_CREDENTIALS = credentials('9248e92a-dba9-491c-849b-472e3d3ca7fa') // Replace with your Jenkins credentials ID
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
          sh 'mvn clean install'
        }
      }
    }

    stage('Unit Test') {
      steps {
        script {
          // Run unit tests with Maven (optional: skip if you want to run in a later stage)
          sh 'mvn clean test -B -Dmaven.test.failure.ignore=false'
        }
      }
    }

    stage('Package') {
      steps {
        script {
          // Package the application into a JAR, WAR, or Docker image
          sh 'mvn package -B -DskipTests'
        }
      }
    }

    stage('Deploy to Nexus') {
      steps {
        script {
          // Deploy the artifact to Nexus
          sh """
           mvn deploy:deploy-file \
                                   -Durl=${NEXUS_URL}/repository/${NEXUS_REPO}/ \
                                   -DrepositoryId=nexus \
                                   -Dfile=target/your-artifact.jar \
                                   -DgroupId=com.example \
                                   -DartifactId=your-artifact \
                                   -Dversion=1.0.${BUILD_NUMBER} \
                                   -Dpackaging=jar \
                                   -DgeneratePom=true
          """
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
    echo 'Pipeline failed, check the logs for details.'
  }
}