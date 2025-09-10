variable "vpc_id" {
  description = "The VPC ID where the SG will be created"
  type        = string
}

variable "ingress_cidr" {
  description = "CIDR block allowed to connect (e.g., VPC CIDR or 0.0.0.0/0)"
  type        = string
}

variable "sg_name" {
  description = "Name of the Security Group"
  type        = string
  default     = "allow_tls"
}

variable "sg_description" {
  description = "Description of the Security Group"
  type        = string
  default     = "Allow TLS inbound traffic and all outbound traffic"
}

