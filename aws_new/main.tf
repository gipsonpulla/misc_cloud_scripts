terraform {
    backend "s3" {
        bucket = "gipsonk8sb34s3buk"
        key    = "terraform.tfstate"
        region = "us-east-1"
        use_lockfile = true
    }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Security group to allow SSH access"

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  
}

resource "aws_instance" "web_server" {
  ami           = "ami-07ff62358b87c7116"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.allow_ssh.name]

  tags = {
    Name = "WebServerInstance"
  }
  
}