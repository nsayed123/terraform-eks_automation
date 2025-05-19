variable "vpc_id" {
  type        = string
  description = "VPC ID where bastion is deployed"
}

variable "subnet_id" {
  type        = string
  description = "Public subnet ID for bastion host"
}

variable "key_name" {
  type        = string
  description = "EC2 Key pair name for bastion SSH"
}

variable "allowed_ips" {
  type        = list(string)
  description = "CIDR blocks allowed to SSH into bastion"
}

