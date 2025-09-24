def call(String DockerHubUser , String ImageTag , String Project){
  sh "docker rmi -f ${DockerHubUser}/${Project}:${ImageTag}"
}

