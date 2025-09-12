
resource "aws_vpc" "my-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name      = "${var.project}-${var.region}-VPC"
    TF_Module = "standard_vpc"
  }
}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name      = "${var.project}-${var.region}-IGW"
    TF_Module = "standard_vpc"
  }
}

resource "aws_subnet" "public" {
  count                   = 3
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.0.${count.index}.0/24" 
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project}-${var.region}-public-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
  tags = {
    Name = "${var.project}-${var.region}-public-route-table "
  }

}

resource "aws_route_table_association" "public" {
  count          = 3
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Create Private Subnets
resource "aws_subnet" "private" {
  count             = 3
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.${count.index + 10}.0/24" 
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name        = "${var.project}-${var.region}-private-subnet-${count.index + 1}"
  }
}

# Create Private Route Tables
resource "aws_route_table" "private" {
  count  = 3
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name        = "${var.project}-${var.region}-private-route-table-${count.index + 1}"
  }
}

# Connect private route table to private subnets
resource "aws_route_table_association" "private" {
  count          = 3
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}