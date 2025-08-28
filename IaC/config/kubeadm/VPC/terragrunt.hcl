include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/VPC"
}

inputs = {
  vpc_cidr                  = "10.0.0.0/16"
  public_cidr               = "10.0.1.0/24"
  private_cidr              = "10.0.11.0/24"
  vpc_name                  = "TASK-VPC"
  public_subnet_name        = "TASK-PUBLIC_SUBNET"
  public_subnet_route_name  = "TASK-PUBLIC_SUBNET_RT"
  private_subnet_name       = "TASK-PRIVATE_SUBNET"
  private_subnet_route_name = "TASK-PRIVATE_SUBNET_RT"
}