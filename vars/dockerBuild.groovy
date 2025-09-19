def call(String DockerHubUser ,  String ImageTag , String Project){
  sh "docker build -t ${DockerHubUser}/${ProjectName}:${ImageTag} ./server/Dockerfile"
}
