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

