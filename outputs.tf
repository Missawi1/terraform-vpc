output "vpc_id" {
  value = aws_vpc.main.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

output "route_table_id" {
  value = aws_route_table.public.id
}

output "dhcp_options_id" {
  value = aws_vpc_dhcp_options.dns_resolver.id
}

output "network_acl_id" {
  value = aws_network_acl.main.id
}