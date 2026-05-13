locals {
  all_ips    = "0.0.0.0/0"
  http_port  = 80
  https_port = 443
  ssh_port   = 22

  ephemeral_ports = {
    from = 1024,
    to   = 65535
  }
}

resource "aws_route" "enable_public_subnet" {
  route_table_id         = module.vpc.route_table_id
  destination_cidr_block = local.all_ips
  gateway_id             = module.vpc.gateway_id
}

resource "aws_network_acl_rule" "allow_inbound_ssh" {
  network_acl_id = module.vpc.network_acl_id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = local.all_ips
  from_port      = local.ssh_port
  to_port        = local.ssh_port
}

resource "aws_network_acl_rule" "allow_inbound_http" {
  network_acl_id = module.vpc.network_acl_id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = local.all_ips
  from_port      = local.http_port
  to_port        = local.http_port
}

resource "aws_network_acl_rule" "allow_inbound_https" {
  network_acl_id = module.vpc.network_acl_id
  rule_number    = 105
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = local.all_ips
  from_port      = local.https_port
  to_port        = local.https_port
}

resource "aws_network_acl_rule" "allow_inbound_return_internet_traffic" {
  network_acl_id = module.vpc.network_acl_id
  rule_number    = 115
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = local.all_ips
  from_port      = local.ephemeral_ports.from
  to_port        = local.ephemeral_ports.to
}

resource "aws_network_acl_rule" "allow_outbound_return_traffic" {
  network_acl_id = module.vpc.network_acl_id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = local.all_ips
  from_port      = local.ephemeral_ports.from
  to_port        = local.ephemeral_ports.to
}

resource "aws_network_acl_rule" "allow_outbound_http" {
  network_acl_id = module.vpc.network_acl_id
  rule_number    = 105
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = local.all_ips
  from_port      = local.http_port
  to_port        = local.http_port
}

resource "aws_network_acl_rule" "allow_outbound_https" {
  network_acl_id = module.vpc.network_acl_id
  rule_number    = 110
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = local.all_ips
  from_port      = local.https_port
  to_port        = local.https_port
}

resource "aws_vpc_security_group_ingress_rule" "authorize_inbound_ssh" {
  security_group_id = module.web_server.security_group_id
  cidr_ipv4         = local.all_ips
  ip_protocol       = "tcp"
  from_port         = local.ssh_port
  to_port           = local.ssh_port
}

resource "aws_vpc_security_group_ingress_rule" "authorize_inbound_http" {
  security_group_id = module.web_server.security_group_id
  cidr_ipv4         = local.all_ips
  ip_protocol       = "tcp"
  from_port         = local.http_port
  to_port           = local.http_port
}

resource "aws_vpc_security_group_ingress_rule" "authorize_inbound_https" {
  security_group_id = module.web_server.security_group_id
  cidr_ipv4         = local.all_ips
  ip_protocol       = "tcp"
  from_port         = local.https_port
  to_port           = local.https_port
}

resource "aws_vpc_security_group_ingress_rule" "authorize_return_internet_traffic" {
  security_group_id = module.web_server.security_group_id
  cidr_ipv4         = local.all_ips
  ip_protocol       = "tcp"
  from_port         = local.ephemeral_ports.from
  to_port           = local.ephemeral_ports.to
}

resource "aws_vpc_security_group_egress_rule" "authorize_outbound_http" {
  security_group_id = module.web_server.security_group_id
  cidr_ipv4         = local.all_ips
  ip_protocol       = "tcp"
  from_port         = local.http_port
  to_port           = local.http_port
}

resource "aws_vpc_security_group_egress_rule" "authorize_outbound_https" {
  security_group_id = module.web_server.security_group_id
  cidr_ipv4         = local.all_ips
  ip_protocol       = "tcp"
  from_port         = local.https_port
  to_port           = local.https_port
}

moved {
  from = aws_network_acl_rule.allow_outbound_ssh_http_https
  to   = aws_network_acl_rule.allow_outbound_return_traffic
}

moved {
  from = aws_vpc_security_group_ingress_rule.authorize_http
  to   = aws_vpc_security_group_ingress_rule.authorize_inbound_http
}

moved {
  from = aws_vpc_security_group_ingress_rule.authorize_https
  to   = aws_vpc_security_group_ingress_rule.authorize_inbound_https
}

moved {
  from = aws_vpc_security_group_ingress_rule.authorize_ssh
  to   = aws_vpc_security_group_ingress_rule.authorize_inbound_ssh
}