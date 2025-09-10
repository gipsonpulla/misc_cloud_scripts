resource "aws_security_group" "my-sg" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id

  tags = {
    Name = var.sg_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "tls_ipv4" {
  security_group_id = aws_security_group.my-sg.id
  cidr_ipv4         = var.ingress_cidr
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "all_traffic_ipv4" {
  security_group_id = aws_security_group.my-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

