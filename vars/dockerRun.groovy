<<<<<<< HEAD
def call(String DockerHubUser, String ImageTag ,String ProjectName){

    def oldTag = sh(
        script: "docker ps --filter 'name=ws' --format '{{.Image}}' | awk -F ':' '{print \$2}'",
        returnStdout: true
    ).trim()

  if (oldTag && oldTag != ImageTag) {
        echo "Old container with tag ${oldTag} found. Removing..."
        sh "docker rm -f ws} || true"
    }
  sh "docker rm -f ws} || true"
  echo "Deploying container with tag ${ImageTag}"
  sh "docker run -d -p 8080:8080 -name=ws ${DockerHubUser}/${ProjectName}:${ImageTag}"
}
The project focused on deploying a WebSocket server and applying load testing to evaluate system stability under real-time communication with multiple concurrent users. The server was developed and containerized with custom metrics exposed on the /metrics endpoint, enabling monitoring and observability. To validate performance, K6 load testing was integrated to simulate high traffic and measure system responsiveness. A CI/CD pipeline was configured in Jenkins to fully automate the workflow, including code checkout from GitHub, SonarQube analysis for code quality gates, OWASP Dependency Check for library vulnerabilities, Trivy scanning for container image vulnerabilities, Docker image build and push to a private Docker Hub repository, and finally automatic container deployment on the target server.
=======
def call(String DockerHubUser, String ImageTag ,String ProjectName){
  sh "docker rm -f ws || true"
  echo "Deploying container with tag ${ImageTag}"
  sh "docker run -d -p 9090:8080 --name=ws ${DockerHubUser}/${ProjectName}:${ImageTag}"
}



>>>>>>> 676d821bc76ef755d72f4fbd783afbcd4fd1633f
