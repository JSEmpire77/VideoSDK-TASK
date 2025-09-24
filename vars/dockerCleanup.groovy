<<<<<<< HEAD
def call(String DockerHubUser , String ImageTag , String Project){
  sh "docker rmi ${DockerHubUser}/${Project}:${ImageTag}"
}
=======
def call(String DockerHubUser , String ImageTag , String Project){
  sh "docker rmi -f ${DockerHubUser}/${Project}:${ImageTag}"
}

>>>>>>> 676d821bc76ef755d72f4fbd783afbcd4fd1633f
