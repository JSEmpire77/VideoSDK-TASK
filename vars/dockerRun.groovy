def call(String DockerHubUser, String ImageTag ,String ProjectName){
  sh "docker rm -f ws || true"
  echo "Deploying container with tag ${ImageTag}"
  sh "docker run -d -p 9090:8080 --name=ws ${DockerHubUser}/${ProjectName}:${ImageTag}"
}



