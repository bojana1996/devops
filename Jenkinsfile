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

    agent any

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
        NEXUS_REPOSITORY = "maven-public"
        // Jenkins credential id to authenticate to Nexus OSS
        NEXUS_CREDENTIAL_ID = "9248e92a-dba9-491c-849b-472e3d3ca7fa"
    }

    stages {
        stage("Hello"){
            steps{
                echo "Hello"
            }
        }
        stage("clone code") {
            steps {
                script {
                    // Let's clone the source
                    git (
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
//                 script {
//                     // Read POM xml file using 'readMavenPom' step , this step 'readMavenPom' is included in: https://plugins.jenkins.io/pipeline-utility-steps
//                     pom = readMavenPom file: "pom.xml";
//                     // Find built artifact under target folder
//                     filesByGlob = findFiles(glob: "target/*.${pom.packaging}");
//                     // Print some info from the artifact found
//                     echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
//                     // Extract the path from the File found
//                     artifactPath = filesByGlob[0].path;
//                     // Assign to a boolean response verifying If the artifact name exists
//                     artifactExists = fileExists artifactPath;
//
//                     if(artifactExists) {
//                         echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}";
//
//                         nexusArtifactUploader(
//                             nexusVersion: NEXUS_VERSION,
//                             protocol: NEXUS_PROTOCOL,
//                             nexusUrl: NEXUS_URL,
//                             groupId: pom.groupId,
//                             version: pom.version,
//                             repository: NEXUS_REPOSITORY,
//                             credentialsId: NEXUS_CREDENTIAL_ID,
//                             artifacts: [
//                                 // Artifact generated such as .jar, .ear and .war files.
//                                 [artifactId: pom.artifactId,
//                                 classifier: '',
//                                 file: artifactPath,
//                                 type: pom.packaging],
//
//                                 // Lets upload the pom.xml file for additional information for Transitive dependencies
//                                 [artifactId: pom.artifactId,
//                                 classifier: '',
//                                 file: "pom.xml",
//                                 type: "pom"]
//                             ]
//                         );
//
//                     } else {
//                         error "*** File: ${artifactPath}, could not be found";
//                     }
//                 }
              nexusArtifactUploader artifacts: [[artifactId: 'demo', classifier: '', file: 'target/demo-0.0.1-SNAPSHOT.jar', type: '.jar']], credentialsId: '988409bc-1c81-4a87-aa49-0daed79d25f1', groupId: 'com.example', nexusUrl: 'nexus:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'maven-snapshots', version: '0.0.1'
            }
        }
}
}