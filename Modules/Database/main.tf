resource "aws_db_subnet_group" "sub_group_db" {
  name       = "${var.name}-db-subnets"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name    = "${var.name}-db-subnets"
    Managed = "terraform"
  }
}


resource "aws_security_group" "sg_db" {
  name   = "${var.name}-db-sg"
  vpc_id = var.vpc_id

  ingress {
    description     = "From app SG"
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [var.app_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_db_instance" "instance_db" {
  identifier              = "${var.name}-db"
  engine                  = var.engine
 #engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.storage_gb
  db_subnet_group_name    = aws_db_subnet_group.sub_group_db.name
  vpc_security_group_ids  = [aws_security_group.sg_db.id]
  username                = var.db_username
  password                = var.db_password
  port                    = var.db_port
  multi_az                = false
  publicly_accessible     = false
  storage_encrypted       = true
  skip_final_snapshot     = true
  deletion_protection     = false
  apply_immediately       = true
  tags                    = var.tags
}
