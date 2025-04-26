// pipeline {
//   agent any
//   tools {
//     maven Maven
//   }
//
//   environment {
//     NEXUS_URL = 'http://nexus:8081'
//     NEXUS_REPO = 'maven-public'
//     NEXUS_CREDENTIALS = credentials('9248e92a-dba9-491c-849b-472e3d3ca7fa') // Replace with your Jenkins credentials ID
//   }
//   stages {
//     stage('Checkout') {
//       steps {
//         // Checkout code from Git repository (Gitea, GitHub, etc.)
//         git credentialsId: 'admin:efdc7a3d42284c87b9a03a031b32d146', url: 'http://gitea:3000/ci_cd.git'
//       }
//     }
//
//     stage('Build') {
//       steps {
//         script {
//           // Use Maven to build the project (compiling the code)
//           // This could be changed to other build tools like Gradle
//           sh 'mvn clean install'
//         }
//       }
//     }
//
//     stage('Unit Test') {
//       steps {
//         script {
//           // Run unit tests with Maven (optional: skip if you want to run in a later stage)
//           sh 'mvn clean test -B -Dmaven.test.failure.ignore=false'
//         }
//       }
//     }
//
//     stage('Package') {
//       steps {
//         script {
//           // Package the application into a JAR, WAR, or Docker image
//           sh 'mvn package -B -DskipTests'
//         }
//       }
//     }
//
//     stage('Deploy to Nexus') {
//       steps {
//         script {
//           // Deploy the artifact to Nexus
//           sh """
//            mvn deploy:deploy-file \
//                                    -Durl=${NEXUS_URL}/repository/${NEXUS_REPO}/ \
//                                    -DrepositoryId=nexus \
//                                    -Dfile=target/your-artifact.jar \
//                                    -DgroupId=com.example \
//                                    -DartifactId=your-artifact \
//                                    -Dversion=1.0.${BUILD_NUMBER} \
//                                    -Dpackaging=jar \
//                                    -DgeneratePom=true
//           """
//         }
//       }
//     }
//   }
//
// }
//
// post {
//   success {
//     echo 'Pipeline completed successfully!'
//   }
//   failure {
//     echo 'Pipeline failed, check the logs for details.'
//   }
// }

pipeline {

  agent {
          docker {
              image 'docker:latest'  // Docker image to use
              args '-v /var/run/docker.sock:/var/run/docker.sock'  // Mount Docker socket
          }
      }

  tools {
    // Note: this should match with the tool name configured in your jenkins instance (JENKINS_URL/configureTools/)
    maven "Maven"
  }

  environment {
    // This can be nexus3 or nexus2
    NEXUS_VERSION = "nexus3"
    // This can be http or https
    NEXUS_PROTOCOL = "http"
    // Where your Nexus is running
    NEXUS_URL = "nexus:8081"
    // Repository where we will upload the artifact
    NEXUS_REPOSITORY = "maven-snapshots"
    // Jenkins credential id to authenticate to Nexus OSS
    NEXUS_CREDENTIAL_ID = "9248e92a-dba9-491c-849b-472e3d3ca7fa"
  }

  stages {
    stage("Hello") {
      steps {
        echo "Hello"
      }
    }

    stage("clone code") {
      steps {
        script {
          // Let's clone the source
          git(
            branch: 'main',
            credentialsId: 'a9499c5c-d4ec-4267-b131-363495a49924',
            url: 'http://gitea:3000/admin/ci_cd.git',
          )
        }
      }
    }

    stage('Build') {
      steps {
        script {
          // Use Maven to build the project (compiling the code)
          // This could be changed to other build tools like Gradle
          sh "mvn clean install"
        }
      }
    }
    stage("mvn build") {
      steps {
        script {
          // If you are using Windows then you should use "bat" step
          // Since unit testing is out of the scope we skip them
          sh "mvn package -DskipTests=true"
        }
      }
    }

    stage("publish to nexus") {
      steps {
        script {
          pom = readMavenPom file: "pom.xml";
          filesByGlob = findFiles(glob: "target/*.${pom.packaging}");
          echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
          artifactPath = filesByGlob[0].path;
          artifactExists = fileExists artifactPath;

          if (artifactExists) {
            echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}";

            nexusArtifactUploader(
              nexusVersion: NEXUS_VERSION,
              protocol: NEXUS_PROTOCOL,
              nexusUrl: NEXUS_URL,
              groupId: pom.groupId,
              version: pom.version,
              repository: NEXUS_REPOSITORY,
              credentialsId: NEXUS_CREDENTIAL_ID,
              artifacts: [

                [artifactId: pom.artifactId,
                  classifier: '',
                  file: artifactPath,
                  type: pom.packaging
                ],

                [artifactId: pom.artifactId,
                  classifier: '',
                  file: "pom.xml",
                  type: "pom"
                ]
              ]
            );

          } else {
            error "*** File: ${artifactPath}, could not be found";
          }
        }
      }

    }

    stage('Build and push Docker image') {
          steps {
            script {
                      withDockerRegistry(credentialsId: 'dockerhub_credentials', url: 'https://index.docker.io/v1/') {
                          sh "docker build -t mydockeruser/my-image:latest ."
                          sh "docker push bojjana/my-image:latest"
                      }
//             sh 'docker build -t my-image:latest .'
//             sh 'docker push my-image:latest'
          }
        }

//     stage('Deploy to Kubernetes') {
//
//           steps {
//
//             kubernetesDeploy(
//
//               configs: 'deployment.yaml'
//
//             )
//
//           }
//
//         }
//   }
}