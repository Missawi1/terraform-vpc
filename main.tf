resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags       = var.tag
}

resource "aws_subnet" "public" {
  for_each          = { for az in local.availability_zones : az => az }
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.public_subnet_cidr_blocks[each.key]
  availability_zone = each.value
  tags = {
    name = "public_subnet_${each.value}"
  }
}

resource "aws_subnet" "private" {
  for_each          = { for az in local.availability_zones : az => az }
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_subnet_cidr_blocks[each.key]
  availability_zone = each.value
  tags = {
    name = "private_subnet_${each.value}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = var.tag
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = var.tag
}

resource "aws_route_table_association" "public" {
  for_each       = { for az in local.availability_zones : az => az }
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[each.key].id
}

/*resource "aws_eip" "lb" {
  instance = aws_instance.web.id
  domain   = "vpc"
}

resource "aws_nat_gateway" "public" {
  allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.public[each.key].id

  depends_on = [aws_internet_gateway.igw]
}*/

resource "aws_nat_gateway" "private" {
  for_each       = { for az in local.availability_zones : az => az }
  connectivity_type = "private"
  subnet_id         = aws_subnet.private[each.key].id
}

resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name = "devopslearnings.click"
  domain_name_servers = ["AmazonProvidedDNS"]
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.dns_resolver.id
}

resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "10.0.0.0/16"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "-1"  # Any protocol
    rule_no    = 300
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  egress {
    protocol   = "udp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "10.0.0.0/16"
    from_port  = 123
    to_port    = 123
  }

  egress {
    protocol   = "-1"  # Any protocol
    rule_no    = 300
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }
  }

  resource "aws_network_acl_association" "main" {
  for_each       = { for az in local.availability_zones : az => az }
  network_acl_id = aws_network_acl.main.id
  subnet_id      = aws_subnet.public[each.key].id
}

/*resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.us-west-2.s3"
}

/*resource "aws_vpc_peering_connection" "foo" {
  peer_owner_id = data.aws_caller_identity.current.account_id
  peer_vpc_id   = aws_vpc.main.id
  vpc_id        = aws_vpc.main.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}*/
