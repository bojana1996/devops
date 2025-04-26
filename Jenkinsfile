pipeline {
  agent {
    docker {
      image 'docker:latest'  // Docker image to use
      args '-v /var/run/docker.sock:/var/run/docker.sock'  // Mount Docker socket
    }
  }

  tools {
    maven "Maven"  // Maven tool setup
  }

  environment {
    // Nexus details
    NEXUS_VERSION = "nexus3"
    NEXUS_PROTOCOL = "http"  // Can be http or https
    NEXUS_URL = "nexus:8081"
    NEXUS_REPOSITORY = "maven-snapshots"
    NEXUS_CREDENTIAL_ID = "9248e92a-dba9-491c-849b-472e3d3ca7fa"  // Jenkins credential ID for Nexus
  }

  stages {
    stage("Hello") {
      steps {
        echo "Hello"
      }
    }

    stage("Clone Code") {
      steps {
        script {
          // Clone the repository
          git(
            branch: 'main',
            credentialsId: 'a9499c5c-d4ec-4267-b131-363495a49924',
            url: 'http://gitea:3000/admin/ci_cd.git'
          )
        }
      }
    }

    stage('Build') {
      steps {
        script {
          // Use Maven to clean and install dependencies
          sh "mvn clean install"
        }
      }
    }

    stage("Maven Build") {
      steps {
        script {
          // Skip tests during package stage
          sh "mvn package -DskipTests=true"
        }
      }
    }

    stage("Publish to Nexus") {
      steps {
        script {
          // Read pom.xml file
          pom = readMavenPom file: "pom.xml"

          // Find the artifact in target directory
          filesByGlob = findFiles(glob: "target/*.${pom.packaging}")
          echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"

          artifactPath = filesByGlob[0].path
          artifactExists = fileExists artifactPath

          if (artifactExists) {
            echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}"

            // Upload artifact to Nexus
            nexusArtifactUploader(
              nexusVersion: NEXUS_VERSION,
              protocol: NEXUS_PROTOCOL,
              nexusUrl: NEXUS_URL,
              groupId: pom.groupId,
              version: pom.version,
              repository: NEXUS_REPOSITORY,
              credentialsId: NEXUS_CREDENTIAL_ID,
              artifacts: [
                [artifactId: pom.artifactId, classifier: '', file: artifactPath, type: pom.packaging],
                [artifactId: pom.artifactId, classifier: '', file: "pom.xml", type: "pom"]
              ]
            )
          } else {
            error "*** File: ${artifactPath}, could not be found"
          }
        }
      }
    }

    stage('Build and Push Docker Image') {
      steps {
        script {
          withDockerRegistry(credentialsId: 'dockerhub_credentials', url: 'https://index.docker.io/v1/') {
            sh "docker build -t bojjana/my-image:latest ."
            sh "docker push bojjana/my-image:latest"
          }
        }
      }
    }

    // stage('Deploy to Kubernetes') {
    //   steps {
    //     kubernetesDeploy(
    //       configs: 'deployment.yaml'  // Path to Kubernetes deployment YAML file
    //     )
    //   }
    // }
  }

  post {
    success {
      echo "Pipeline completed successfully!"
    }
    failure {
      echo "Pipeline failed. Check the logs for details."
    }
  }
}