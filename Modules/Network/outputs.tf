output "vpc_id" {
  value       = aws_vpc.my_vpc_three_tier.id
  description = "ID of the VPC"
}

output "public_subnet_ids" {
  value       = [for s in aws_subnet.public : s.id]
  description = "IDs of public (web) subnets"
}

output "app_subnet_ids" {
  value       = [for s in aws_subnet.app : s.id]
  description = "IDs of private application subnets"
}

output "db_subnet_ids" {
  value       = [for s in aws_subnet.db : s.id]
  description = "IDs of private database subnets"
}
