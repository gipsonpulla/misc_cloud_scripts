variable "ami" {
  type        = string
  description = "AMI ID for EC2"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for EC2"
}

variable "instance_name" {
  type        = string
  description = "Name for the EC2 instance"
}

