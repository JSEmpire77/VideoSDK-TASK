variable "port_module" {
  type = list(number)
}

variable "port_module_2" {
  type = list(number)
}

variable "ami_id" {
  type = string
}

variable "ami_id_2" {
  type = string
}

variable "instance_type_2" {
  type = string
}

variable "instance_type_1" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet" {
  type = string
}

variable "public_subnet" {
  type = string
}

# variable "key" {
#   type      = string
#   sensitive = true
# }

variable "lb_id" {
  type      = string
}

variable "iam" {
  type = string
}
