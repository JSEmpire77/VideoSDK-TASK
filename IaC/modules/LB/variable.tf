variable "subnet_ids" {
  type = list(string)
}

variable "port_module" {
  type = list(number)
}

variable "target_port" {
  type = number
}

variable "vpc_id" {
  type = string
}

variable "listener_port" {
  type = number
}
