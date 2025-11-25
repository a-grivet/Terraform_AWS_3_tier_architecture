locals {
  tags = {
    Project = var.name
    Managed = "terraform"
  }
}

module "network" {
  source = "./Modules/Network"

  name  = var.name
  vpc_cidr = var.vpc_cidr
  azs      = var.azs

  public_subnet_cidrs = var.public_subnet_cidrs
  app_subnet_cidrs    = var.app_subnet_cidrs
  db_subnet_cidrs     = var.db_subnet_cidrs

  create_nat = var.create_nat

  tags = {
    Project = var.name
    Managed = "terraform"
  }
}

module "compute" {
  source             = "./Modules/Compute"
  name               = var.name
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.app_subnet_ids
  http_port          = var.http_port
  instance_type      = var.instance_type
  desired_capacity   = var.desired_capacity
  min_size           = var.min_size
  max_size           = var.max_size
  ssh_cidr           = var.ssh_cidr
  user_data_path = var.user_data_path
  tags               = local.tags
  ami_id             = var.ami_id
}

module "database" {
  source             = "./Modules/Database"
  name               = var.name
  vpc_id             = module.network.vpc_id
  db_subnet_ids = module.network.db_subnet_ids
  app_sg_id          = module.compute.app_sg_id

  engine             = var.db_engine
  engine_version     = var.db_engine_ver
  instance_class     = var.db_instance
  storage_gb         = var.db_storage_gb
  db_username        = var.db_username
  db_password        = var.db_password
  db_port            = var.db_port
  tags               = local.tags
}

