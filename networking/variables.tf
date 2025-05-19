### Providers Config
variable "aws_profile" {

}
variable "aws_region" {

}

### Backend Config
variable "backend_bucket" {

}

variable "backend_dynamodb_table" {

}
variable "backend_key" {

}
variable "backend_region" {

}

### VPC, Subnets
variable "vpc_name" {

}
variable "cidr_block" {

}
variable "azs" {

}
variable "public_subnet_cidrs" {

}
variable "private_subnet_cidrs_eks" {

}
variable "private_subnet_cidrs_rds" {

}

###Bastion
variable "key_name" {
  description = "Name of the EC2 Key Pair for Bastion Host"
  type        = string
}