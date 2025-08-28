include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/EC2"
}

dependency "VPC" {
  config_path = "../VPC"
  mock_outputs = {
    vpc_id            = "mock-vpc-id"
    public_subnet_id  = "mock-public-subnet-id"
    private_subnet_id = "mock-private-subnet-id"
  }
}

dependency "LB" {
  config_path = "../LB"
  mock_outputs = {
    lb_sg_id = "mock-lb-sg-id"
  }
}

dependency "IAM" {
  config_path = "../IAM"
  mock_outputs = {
    iam_instance_profile = "mock-iam-instance-profile"
  }
}

inputs = {
  ami_id          = "ami-084568db4383264d4"
  ami_id_2        = "ami-0f9de6e2d2f067fca"
  instance_type_1 = "t2.micro"
  instance_type_2 = "t2.medium"
  vpc_id          = dependency.VPC.outputs.vpc_id
  # key             = file("${get_repo_root()}/IaC/modules/EC2/id_rsa.pub")
  iam             = dependency.IAM.outputs.iam_instance_profile
  lb_id           = dependency.LB.outputs.lb_sg_id
  private_subnet  = dependency.VPC.outputs.private_subnet_id
  public_subnet   = dependency.VPC.outputs.public_subnet_id
  port_module     = [22, 80, 8080, 443, 6443, 10250, 10259, 10257, 2379, 2380, 10254]
  port_module_2   = [22, 80, 10250, 10256]
}
