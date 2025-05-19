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

module "network" {
  source = "../modules/network"

  vpc_name   = var.vpc_name
  cidr_block = var.cidr_block
  # secondary_cidr_block = "100.64.0.0/16"

  azs = var.azs

  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs_eks = var.private_subnet_cidrs_eks
  # secondary_private_subnet_cidrs_eks = [
  #   "100.64.1.0/24",  # AZ-a
  #   "100.64.2.0/24",  # AZ-b
  #   "100.64.3.0/24"   # AZ-c
  # ]

  private_subnet_cidrs_rds = var.private_subnet_cidrs_rds
}

module "bastion" {
  source      = "../modules/bastion"
  vpc_id      = module.network.vpc_id
  subnet_id   = module.network.public_subnet_ids[0]
  key_name    = var.key_name
  allowed_ips = ["${chomp(data.http.myip.response_body)}/32"]
}

