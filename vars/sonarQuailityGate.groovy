def call(){
  timeout(time: 1, unit: "MINUTES"){       // wait for 1 minute ater that move to next stage.
      waitForQualityGate abortPipeline: false
  }
}

