include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/Cloud_watch"
}

dependency "ASG" {
  config_path = "../ASG"
  mock_outputs = {
    asg_name              = "mock-asg-name"
    scale_up_policy_arn   = "mock-scale-up-policy-arn"
    scale_down_policy_arn = "mock-scale-down-policy-arn"
  }
}

inputs = {
  notification_email    = "vivekkothiya464@gmail.com"
  asg_name              = dependency.ASG.outputs.asg_name
  scale_up_policy_arn   = dependency.ASG.outputs.scale_up_policy_arn
  scale_down_policy_arn = dependency.ASG.outputs.scale_down_policy_arn
}