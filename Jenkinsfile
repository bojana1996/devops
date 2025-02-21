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
        NEXUS_REPOSITORY = "maven-snapshots"
        // Jenkins credential id to authenticate to Nexus OSS
        NEXUS_CREDENTIAL_ID = "988409bc-1c81-4a87-aa49-0daed79d25f1"
        registryCredential = "docker-hub"
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
        
        stage('Initialize') {
           def dockerHome = tool 'myDocker'
           env.PATH = "${dockerHome}/bin:${env.PATH}"
        } 

        stage('Building image') {
         steps{
           script {
          dockerImage = docker.build "java-app"
        }
      }
    }

    stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push("$BUILD_NUMBER")
             dockerImage.push('latest')

          }
        }
      }
    }

    stage('Deploy to K8s') {
      steps{
        script {
          sh "sed -i 's,TEST_IMAGE_NAME,harshmanvar/node-web-app:$BUILD_NUMBER,' deployment.yaml"
          sh "cat deployment.yaml"
          sh "kubectl --kubeconfig=/home/ec2-user/config get pods"
          sh "kubectl --kubeconfig=/home/ec2-user/config apply -f deployment.yaml"
        }
      }
    }

    }
}