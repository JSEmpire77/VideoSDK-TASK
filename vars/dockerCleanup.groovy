def call(String DockerHubUser , String ImageTag , String Project){
  sh "docker rmi ${DockerHubUser}/${Project}:${ImageTag}"
}

