include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/ASG"
}

dependency "VPC" {
  config_path = "../VPC"
  mock_outputs = {
    private_subnet_id = "mock-private-subnet-id"
  }
}

dependency "LB" {
  config_path = "../LB"
  mock_outputs = {
    target_group_arn = "mock-target-group-arn"
  }
}

dependency "EC2" {
  config_path = "../EC2"
  mock_outputs = {
    template_name = "mock-template-name"
  }
}

inputs = {
  min_size          = 1
  max_size          = 2
  desired_capacity  = 1
  target_group_arns = [dependency.LB.outputs.target_group_arn]
  launch_template   = dependency.EC2.outputs.template_name
  subnet_ids        = dependency.VPC.outputs.private_subnet_id
}