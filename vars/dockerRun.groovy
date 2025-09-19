def call(String DockerHubUser, String ImageTag ,String ProjectName){

    def oldTag = sh(
        script: "docker ps --filter 'name=ws' --format '{{.Image}}' | awk -F ':' '{print \$2}'",
        returnStdout: true
    ).trim()

  if (oldTag && oldTag != ImageTag) {
        echo "Old container with tag ${oldTag} found. Removing..."
        sh "docker rm -f ws} || true"
    }

  echo "Deploying container with tag ${ImageTag}"
  sh "docker run -d -p 8080:8080 -name=ws ${DockerHubUser}/${ProjectName}:${ImageTag}"
}
