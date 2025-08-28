variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "desired_capacity" {
  type = number
}

variable "target_group_arns" {
  type = list(string)
}

variable "subnet_ids" {
  type = string
}

variable "launch_template" {
  type = string
}