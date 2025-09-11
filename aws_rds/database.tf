provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "my-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "my-vpc"

  }
}

resource "aws_subnet" "my-public" {
  count                   = 3
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.0.${count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "my-public-${count.index + 1}"
  }
}

resource "aws_subnet" "my-private" {
  count             = 3
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.${count.index + 10}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "my-private-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
}

resource "aws_route_table" "my-rt" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
}

resource "aws_route_table_association" "public_association" {
  count          = 3
  subnet_id      = aws_subnet.my-public[count.index].id
  route_table_id = aws_route_table.my-rt.id
}

resource "aws_db_subnet_group" "postgres_subnet_group" {
  name       = "postgres-subnet-group"
  subnet_ids = aws_subnet.my-private[*].id
}

# Security Group container
resource "aws_security_group" "postgres" {
  name   = "postgres-sg"
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "postgres-sg"
  }
}

# Ingress rule: allow Postgres traffic from inside VPC
resource "aws_vpc_security_group_ingress_rule" "postgres_ingress" {
  security_group_id = aws_security_group.postgres.id
  cidr_ipv4         = aws_vpc.my-vpc.cidr_block
  from_port         = 5432
  to_port           = 5432
  ip_protocol       = "tcp"
}

# Egress rule: allow all outbound traffic (IPv4)
resource "aws_vpc_security_group_egress_rule" "postgres_egress_ipv4" {
  security_group_id = aws_security_group.postgres.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # all protocols/ports
}

resource "aws_db_instance" "postgres_primary" {
  identifier                = "postgres-primary"
  engine                    = "postgres"
  engine_version            = "16.3"
  instance_class            = "db.m6g.large"
  allocated_storage         = 20
  storage_type              = "gp3"
  multi_az                  = true
  db_name                   = "mydb"
  username                  = "postgres"
  password                  = "My$QL123"
  db_subnet_group_name      = aws_db_subnet_group.postgres_subnet_group.name
  vpc_security_group_ids    = [aws_security_group.postgres.id]
  backup_retention_period   = 7
  backup_window             = "03:00-04:00"
  maintenance_window        = "mon:04:00-mon:04:30"
  skip_final_snapshot       = true
  final_snapshot_identifier = "tf-final-snapshot"
}

resource "aws_db_instance" "postgres_replica" {
  count                   = 2
  identifier              = "postgres-replica-${count.index + 1}"
  instance_class          = "db.m6g.large"
  replicate_source_db     = aws_db_instance.postgres_primary.identifier
  vpc_security_group_ids  = [aws_security_group.postgres.id]
  backup_retention_period = 0
  skip_final_snapshot     = true
}

