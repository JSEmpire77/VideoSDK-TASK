<<<<<<< HEAD
@Library('ws-library') _
pipeline {
    agent any
    
    environment{
        SONAR_HOME = tool "Sonar"
    }
    
    parameters {
        string(name: 'DOCKER_TAG', defaultValue: 'v1', description: 'Setting docker image for latest push')
       
    }
    
    stages {
        stage("Workspace cleanup"){
            steps{
                script{
                    cleanWs()
                }
            }
        }
        
        stage('Git: Code Checkout') {
            steps {
                script{
                    codeCheckout("https://github.com/JSEmpire77/VideoSDK-TASK.git","main")
                }
            }
        }
        
        stage("Trivy: Filesystem scan"){
            steps{
                script{
                    Trivy()
                }
            }
        }

        stage("OWASP: Dependency check"){
            steps{
                script{
                    Owasp()
                }
            }
        }
        
        stage("SonarQube: Code Analysis"){
            steps{
                script{
                    sonarQubeScan("Sonar","Real_time_communication_system","websocket")
                }
            }
        }
        
        stage("SonarQube: Code Quality Gates"){
            steps{
                script{
                    sonarQuailityGate()
                }
            }
        }
        
        stage("Docker: Build Images"){
            steps{
                script{     
                    dockerBuild("vkothiya77","${params.DOCKER_TAG}","ws-app")      
                }
            }
        }
        
        stage("Docker: Push to DockerHub"){
            steps{
                script{
                    dockerPush("vkothiya77","${params.DOCKER_TAG}","ws-app") 
                }
            }
        }

        stage("Docker: Cleanup image from server"){
            steps{
                script{
                    dockerCleanup("vkothiya77","${params.DOCKER_TAG}","ws-app")  
                }
            }
        }

         stage("Docker: Create Container"){
            steps{
                script{
                    dockerRun("vkothiya77","${params.DOCKER_TAG}","ws-app") 
                }
            }
        }

    }
}
=======
@Library('ws-library') _
pipeline {
    agent any
    
    environment{
        SONAR_HOME = tool "Sonar"
    }
    
    parameters {
        string(name: 'DOCKER_TAG', defaultValue: 'v1', description: 'Setting docker image for latest push')
       
    }
    
    stages {
        stage("Workspace cleanup"){
            steps{
                script{
                    cleanWs()
                }
            }
        }
        
        stage('Git: Code Checkout') {
            steps {
                script{
                    codeCheckout("https://github.com/JSEmpire77/VideoSDK-TASK.git","main")
                }
            }
        }
        
        stage("Trivy: Filesystem scan"){
            steps{
                script{
                    Trivy()
                }
            }
        }

        stage("OWASP: Dependency check"){
            steps{
                script{
                    Owasp()
                }
            }
        }
        
        stage("SonarQube: Code Analysis"){
            steps{
                script{
                    sonarQubeScan("Sonar","Real_time_communication_system","websocket")
                }
            }
        }
        
        stage("SonarQube: Code Quality Gates"){
            steps{
                script{
                    sonarQuailityGate()
                }
            }
        }
        
        stage("Docker: Build Images"){
            steps{
                script{     
                    dockerBuild("vkothiya77","${params.DOCKER_TAG}","ws-app")      
                }
            }
        }
        
        stage("Docker: Push to DockerHub"){
            steps{
                script{
                    dockerPush("vkothiya77","${params.DOCKER_TAG}","ws-app") 
                }
            }
        }

        stage("Docker: Cleanup image from server"){
            steps{
                script{
                    dockerCleanup("vkothiya77","${params.DOCKER_TAG}","ws-app")  
                }
            }
        }

         stage("Docker: Create Container"){
            steps{
                script{
                    dockerRun("vkothiya77","${params.DOCKER_TAG}","ws-app") 
                }
            }
        }

    }
}
>>>>>>> 676d821bc76ef755d72f4fbd783afbcd4fd1633f
