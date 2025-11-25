variable "region"          { 
    type = string  
    default = "eu-west-3" 
    }

variable "name"            { 
    type = string  
    default = "three-tier" 
    }

# Network
variable "vpc_cidr"        { 
    type = string  
    default = "10.0.0.0/16" 
    }

variable "azs"             { 
    type = list(string) 
    default = ["eu-west-3a", "eu-west-3b"] 
    }

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "app_subnet_cidrs" {
  type = list(string)
}

variable "db_subnet_cidrs" {
  type = list(string)
}

variable "create_nat" {
  type    = bool
  default = true
}                             

variable "use_nat"         { 
    type = bool   
    default = true
    }

# Compute
variable "http_port"       { 
    type = number 
    default = 80 
    }

variable "instance_type"   { 
    type = string 
    default = "t3.micro" 
    }

variable "desired_capacity"{ 
    type = number 
    default = 2 
    }

variable "min_size"        { 
    type = number 
    default = 2 
    }

variable "max_size"        { 
    type = number 
    default = 4 
    }

variable "ssh_cidr"        { 
    type = string 
    default = null 
    }

variable "ami_id"          { 
    type = string 
    }

variable "user_data_path" {
  description = "Path to the EC2 user data script"
  type        = string
}

# Database
variable "db_engine"       { 
    type = string  
    default = "postgres" 
    }     

variable "db_engine_ver"   { 
    type = string  
    default = "14.12" 
    }

variable "db_instance"     { 
    type = string  
    default = "db.t3.micro" 
    }

variable "db_storage_gb"   { 
    type = number  
    default = 20 
    }

variable "db_port"         { 
    type = number  
    default = 5432 
    }

variable "db_username"     { 
    type = string  
    default = "appuser" 
    }

variable "db_password"     { 
    type = string  
    sensitive = true 
    }

