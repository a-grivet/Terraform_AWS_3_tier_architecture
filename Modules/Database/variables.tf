variable "name"               { 
    type = string 
    }

variable "vpc_id"             { 
    type = string 
    }

variable "db_subnet_ids" {
  type        = list(string)
  description = "Subnets used in the DB subnet group"
}

variable "app_sg_id"          { 
    type = string 
    }

variable "engine"             { 
    type = string 
    default = "postgres"
    }

variable "engine_version"     { 
    type = string 
    default = "14.12" 
    }

variable "instance_class"     { 
    type = string 
    default = "db.t3.micro" 
    }

variable "storage_gb"         { 
    type = number 
    default = 20 
    }

variable "db_username"        { 
    type = string 
    }


variable "db_password"        { 
    type = string 
sensitive = true 
    }

variable "db_port"            { 
    type = number 
    default = 5432 
    }

variable "tags"               { 
    type = map(string) 
    default = {} 
    }


