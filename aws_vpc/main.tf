resource "aws_vpc" "my-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "Mytfvpc"
        }
}

resource "aws_subnet" "my-public" {
    vpc_id = aws_vpc.my-vpc.id
    cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "my-private" {
    vpc_id = aws_vpc.my-vpc.id
    cidr_block = "10.0.2.0/24"
}

resource "aws_internet_gateway" "my-igw" {
    vpc_id = aws_vpc.my-vpc.id
}

resource "aws_route_table" "my-route" {
    vpc_id = aws_vpc.my-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my-igw.id
        }
}

resource "aws_route_table_association" "public_association" {
    subnet_id = aws_subnet.my-public.id
    route_table_id = aws_route_table.my-route.id
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.my-vpc.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

