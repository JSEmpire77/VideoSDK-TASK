include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/LB"
}

dependency "VPC" {
  config_path = "../VPC"
  mock_outputs = {
    vpc_id            = "mock-vpc-id"
    public_subnet_id  = "mock-public-subnet-id"
    private_subnet_id = "mock-private-subnet-id"
  }
}

inputs = {
  subnet_ids    = [dependency.VPC.outputs.public_subnet_id, dependency.VPC.outputs.private_subnet_id]
  port_module   = [80, 443]
  target_port   = 30080
  vpc_id        = dependency.VPC.outputs.vpc_id
  listener_port = 80
}