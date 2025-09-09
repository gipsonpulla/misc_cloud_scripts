variable "vpc_id" {
  type        = string
  description = "VPC ID for the subnet"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the subnet"
}

variable "availability_zone" {
  type        = string
  description = "AZ for the subnet"
}

variable "subnet_name" {
  type        = string
  description = "Name for the subnet"
}

