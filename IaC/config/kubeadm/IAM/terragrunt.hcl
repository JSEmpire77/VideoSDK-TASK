include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/IAM-ROLE"
}

inputs = {
  role             = "task-ec2-ssm-role"
  instance_profile = "task-ec2-ssm-instance-profile"
}
