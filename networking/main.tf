### VPC, Subnets
module "network" {
  source = "../modules/network"

  vpc_name   = var.vpc_name
  cidr_block = var.cidr_block

  azs = var.azs

  public_subnet_cidrs      = var.public_subnet_cidrs
  private_subnet_cidrs_eks = var.private_subnet_cidrs_eks

  private_subnet_cidrs_rds = var.private_subnet_cidrs_rds
}

### Bastion
module "bastion" {
  source      = "../modules/bastion"
  vpc_id      = module.network.vpc_id
  subnet_id   = module.network.public_subnet_ids[0]
  key_name    = var.key_name
  allowed_ips = ["${chomp(data.http.myip.response_body)}/32"]
}

