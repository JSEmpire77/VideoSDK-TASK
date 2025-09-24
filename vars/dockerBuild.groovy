<<<<<<< HEAD
def call(String DockerHubUser ,  String ImageTag , String ProjectName){
  sh "docker build -t ${DockerHubUser}/${ProjectName}:${ImageTag} ./server/Dockerfile"
}
=======
def call(String DockerHubUser ,  String ImageTag , String ProjectName){
  sh "docker build -t ${DockerHubUser}/${ProjectName}:${ImageTag} -f ./server/Dockerfile ./server"
}


>>>>>>> 676d821bc76ef755d72f4fbd783afbcd4fd1633f
