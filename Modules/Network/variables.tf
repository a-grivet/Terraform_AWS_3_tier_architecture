variable "name" {
  type        = string
  description = "Base name for network resources"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "azs" {
  type        = list(string)
  description = "List of AZs to spread subnets across"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDRs for public (web) subnets, one per AZ"
}

variable "app_subnet_cidrs" {
  type        = list(string)
  description = "CIDRs for private application subnets, one per AZ"
}

variable "db_subnet_cidrs" {
  type        = list(string)
  description = "CIDRs for private database subnets, one per AZ"
}

variable "create_nat" {
  type        = bool
  description = "Whether to create a NAT gateway for app tier egress"
  default     = true
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Base tags applied to all network resources"
}
