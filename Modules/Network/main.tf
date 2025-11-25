# Map of index -> AZ
#locals {
# az_map = { for idx, az in var.azs : idx => az }
#}

locals {
  # Tags
  tags = merge(
    {
      Project = var.name
      Managed = "terraform"
    },
    var.tags
  )
}

# VPC
resource "aws_vpc" "my_vpc_three_tier" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.tags, { Name = "${var.name}-vpc" })
}

# Internet Gateway
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.my_vpc_three_tier.id

  tags = merge(local.tags, { Name = "${var.name}-igw" })
}

# ---------- SUBNETS ----------

# Public (web) subnets
resource "aws_subnet" "public" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.my_vpc_three_tier.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    local.tags,
    {
      Name = "${var.name}-public-${var.azs[count.index]}"
      Tier = "public"
    }
  )
}

# Private app subnets
resource "aws_subnet" "app" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.my_vpc_three_tier.id
  cidr_block        = var.app_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    local.tags,
    {
      Name = "${var.name}-app-${var.azs[count.index]}"
      Tier = "app"
    }
  )
}

# Private DB subnets (no internet)
resource "aws_subnet" "db" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.my_vpc_three_tier.id
  cidr_block        = var.db_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    local.tags,
    {
      Name = "${var.name}-db-${var.azs[count.index]}"
      Tier = "db"
    }
  )
}

# ---------- NAT (app tier) ----------

resource "aws_eip" "nat" {
  count      = var.create_nat ? 1 : 0
  domain     = "vpc"
  depends_on = [aws_internet_gateway.ig]

  tags = merge(local.tags, { Name = "${var.name}-nat-eip" })
}

resource "aws_nat_gateway" "this" {
  count         = var.create_nat ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(local.tags, { Name = "${var.name}-nat" })
}

# ---------- ROUTE TABLES ----------

# Public: 0.0.0.0/0 -> IGW
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my_vpc_three_tier.id

  tags = merge(local.tags, { Name = "${var.name}-rtb-public" })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# App: 0.0.0.0/0 -> NAT (if create NAT is true)
resource "aws_route_table" "private_app" {
  vpc_id = aws_vpc.my_vpc_three_tier.id

  tags = merge(local.tags, { Name = "${var.name}-rtb-app" })
}

resource "aws_route" "private_app_nat" {
  count                  = var.create_nat ? 1 : 0
  route_table_id         = aws_route_table.private_app.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id
}

resource "aws_route_table_association" "private_app_assoc" {
  count          = length(aws_subnet.app)
  subnet_id      = aws_subnet.app[count.index].id
  route_table_id = aws_route_table.private_app.id
}

# DB: ONLY local routes (no 0.0.0.0/0) 
resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.my_vpc_three_tier.id

  tags = merge(local.tags, { Name = "${var.name}-rtb-db" })
}

resource "aws_route_table_association" "private_db_assoc" {
  count          = length(aws_subnet.db)
  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.private_db.id
}
