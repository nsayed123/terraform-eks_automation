# module "network" {
#   source = "../modules/network"

#   vpc_name   = "eks-rds-vpc"
#   cidr_block = "10.0.0.0/16"
#   # secondary_cidr_block = "100.64.0.0/16"

#   azs = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]

#   public_subnet_cidrs = [
#     "10.0.1.0/24", # AZ-a
#     "10.0.2.0/24", # AZ-b
#     "10.0.3.0/24"  # AZ-c
#   ]

#   private_subnet_cidrs_eks = [
#     "10.0.11.0/24", # AZ-a
#     "10.0.12.0/24", # AZ-b
#     "10.0.13.0/24"  # AZ-c
#   ]

#   # secondary_private_subnet_cidrs_eks = [
#   #   "100.64.1.0/24",  # AZ-a
#   #   "100.64.2.0/24",  # AZ-b
#   #   "100.64.3.0/24"   # AZ-c
#   # ]

#   private_subnet_cidrs_rds = [
#     "10.0.21.0/24", # AZ-a
#     "10.0.22.0/24", # AZ-b
#     "10.0.23.0/24"  # AZ-c
#   ]
# }

# module "bastion" {
#   source      = "../modules/bastion"
#   vpc_id      = module.network.vpc_id
#   subnet_id   = module.network.public_subnet_ids[0]
#   key_name    = var.key_name
#   allowed_ips = var.bastion_allowed_ips
# }

module "eks" {
  source            = "../modules/eks"
  vpc_id            = data.terraform_remote_state.networking.outputs.vpc_id
  eks_subnet_ids    = data.terraform_remote_state.networking.outputs.private_subnet_ids_eks
  cluster_name      = "prod-eks"
  desired_size      = 2
  min_size          = 1
  max_size          = 4
  key_name          = var.key_name
  bastion_sg_id     = data.terraform_remote_state.networking.outputs.bastion_sg_id
  bastion_role_arn  = data.terraform_remote_state.networking.outputs.bastion_role_arn
  aws_auth_rendered = data.template_file.aws_auth.rendered

}

module "rds" {
  source             = "../modules/rds"
  db_name            = "myappdb"
  db_username        = local.db_secret.username
  db_password        = local.db_secret.password
  subnet_ids         = data.terraform_remote_state.networking.outputs.private_subnet_ids_rds
  vpc_id             = data.terraform_remote_state.networking.outputs.vpc_id
  allowed_source_sgs = [data.terraform_remote_state.networking.outputs.bastion_sg_id, module.eks.eks_node_group_sg]
}

module "ingress" {
  source     = "../modules/controller"
  depends_on = [module.eks]
}

module "route53" {
  source    = "../modules/route53"
  zone_name = "tst-cs.tek.xyz"
  # alb_dns_records = [data.kubernetes_service.nginx_public.status[0].load_balancer[0].ingress[0].hostname]
  alb_dns_records = [local.alb_hostname]
  public_hostname = "superset.tst-cs.tek.xyz"
}

# module "app" {
#   source = "../modules/app"
#   postgres_host = module.rds.db_endpoint
#   domain_name = "superset1.tekioncloud.xyz"
#   ingress_class = "public"
#   postgres_secret_username = local.db_secret.username
#   postgres_secret_password = local.db_secret.password

# }



# module "secrets" {
#   source = "../modules/secrets"
#   secret_name = "rds-db-credentials"
#   secret_data = {
#     username = var.db_username
#     password = var.db_password
#   }
# }

# module "monitoring" {
#   source = "../modules/monitoring"
#   eks_cluster_name = module.eks.cluster_name
#   enable_eks_logs  = true
#   enable_rds_logs  = true
# }
