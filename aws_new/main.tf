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
}

resource "aws_instance" "web_server" {
  ami           = "ami-069e612f612be3a2b"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install -y httpd
                sudo systemctl start httpd
                sudo systemctl enable httpd
                echo "<h1>Welcome to the Web Server</h1>" > /var/www/html/index.html
                EOF

    user_data_replace_on_change = true
  tags = {
    Name = "WebServerInstance"
  }
  
}