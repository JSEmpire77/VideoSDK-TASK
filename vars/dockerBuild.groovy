def call(String DockerHubUser ,  String ImageTag , String ProjectName){
  sh "docker build -t ${DockerHubUser}/${ProjectName}:${ImageTag} -f ./server/Dockerfile .
"
}

