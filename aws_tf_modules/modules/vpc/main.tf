resource "aws_vpc" "my-vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = var.vpc_name
  }
}

