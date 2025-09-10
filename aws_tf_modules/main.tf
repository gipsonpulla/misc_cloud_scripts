provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  vpc_name   = "my-vpc"
}

module "subnet" {
  source            = "./modules/subnet"
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  subnet_name       = "my-public"
}

module "ec2" {
  source        = "./modules/ec2"
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = module.subnet.subnet_id
  instance_name = var.instance_name
  # Attach SG to EC2
  vpc_security_group_ids = [module.sg.security_group_id]
}

module "sg" {
  source     = "./modules/sg"
  vpc_id     = module.vpc.vpc_id
  ingress_cidr  = module.vpc.vpc_cidr_block
  sg_name       = "allow_tls"
  sg_description = "Allow TLS inbound traffic and all outbound traffic"
}
