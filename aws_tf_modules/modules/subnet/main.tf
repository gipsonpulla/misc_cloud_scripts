resource "aws_subnet" "my-public" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_name
  }
}

