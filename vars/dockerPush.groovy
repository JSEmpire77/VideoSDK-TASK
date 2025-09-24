<<<<<<< HEAD
def call( String dockerhubuser, String ImageTag ,String Project){
  withCredentials([usernamePassword(credentialsId: 'docker', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
      sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}"
  }
  sh "docker push ${dockerhubuser}/${Project}:${ImageTag}"
}
=======
def call( String dockerhubuser, String ImageTag ,String Project){
  withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
      sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}"
  }
  sh "docker push ${dockerhubuser}/${Project}:${ImageTag}"
}

>>>>>>> 676d821bc76ef755d72f4fbd783afbcd4fd1633f
