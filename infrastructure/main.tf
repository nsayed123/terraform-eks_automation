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



