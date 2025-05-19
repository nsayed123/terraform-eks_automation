variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of public subnet CIDR blocks"
}

variable "private_subnet_cidrs_eks" {
  type        = list(string)
  description = "List of private subnet CIDRs for EKS"
}

variable "private_subnet_cidrs_rds" {
  type        = list(string)
  description = "List of private subnet CIDRs for RDS"
}


variable "azs" {
  type        = list(string)
  description = "List of availability zones"
}

# variable "secondary_private_subnet_cidrs_eks" {
#   type        = list(string)
#   description = "List of private subnet CIDRs for EKS in the secondary CIDR block"
#   default     = []
# }
# variable "secondary_cidr_block" {

# }