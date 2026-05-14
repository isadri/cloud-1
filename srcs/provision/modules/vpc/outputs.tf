output "route_table_id" {
  description = "The ID of the Subnet Route Table"
  value       = aws_route_table.subnet_route_table.id
}

output "gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.gw.id
}

output "network_acl_id" {
  description = "The ID of the Network ACL"
  value       = aws_network_acl.app_network_acl.id
}

output "subnet_id" {
  description = "The Subnet ID"
  value       = aws_subnet.public.id
}

output "vpc_id" {
  description = "The VPC ID"
  value       = aws_vpc.vpc.id
}