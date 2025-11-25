variable "name"               { type = string }
variable "vpc_id"             { type = string }
variable "public_subnet_ids"  { type = list(string) }
variable "private_subnet_ids" { type = list(string) }

variable "http_port" {
  type    = number
  default = 80
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ami_id" {
  type = string
}

variable "min_size" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 4
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "ssh_cidr" {
  type    = string
  default = null
}

variable "user_data_path" { type = string }

variable "tags" {
  type    = map(string)
  default = {}
}
