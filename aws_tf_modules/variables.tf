variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "ami" {
  type        = string
  description = "AMI for EC2"
  default     = "ami-00ca32bbc84273381"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "instance_name" {
  type        = string
  description = "Name for the EC2 instance"
}

