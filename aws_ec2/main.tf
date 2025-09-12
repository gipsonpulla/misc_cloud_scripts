resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "my-public" {
  count                   = 1
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.0.${count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "my-public-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "my-igw"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "my-public-rt"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.my-public)
  subnet_id      = aws_subnet.my-public[count.index].id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_security_group" "allow_ssh" {
  name   = "allow-ssh"
  vpc_id = aws_vpc.my-vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my-host" {
  count                       = 1
  ami                         = "ami-0b09ffb6d8b58ca91"
  instance_type               = "t2.micro"
  key_name                    = "gips"
  subnet_id                   = aws_subnet.my-public[count.index].id
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true
  tags = {
    Name = "my-instance-${count.index + 1}"
  }
}

