

### EKS cluster
module "eks" {
  source            = "../modules/eks"
  vpc_id            = data.terraform_remote_state.networking.outputs.vpc_id
  eks_subnet_ids    = data.terraform_remote_state.networking.outputs.private_subnet_ids_eks
  cluster_name      = var.eks_cluster_name
  desired_size      = var.eks_ng_desired_size
  min_size          = var.eks_ng_min_size
  max_size          = var.eks_ng_max_size
  key_name          = var.key_name
  bastion_sg_id     = data.terraform_remote_state.networking.outputs.bastion_sg_id
  bastion_role_arn  = data.terraform_remote_state.networking.outputs.bastion_role_arn
  aws_auth_rendered = data.template_file.aws_auth.rendered

}




### Postgres RDS
module "rds" {
  source             = "../modules/rds"
  db_name            = var.rds_cluster_name
  db_username        = local.db_secret.username
  db_password        = local.db_secret.password
  subnet_ids         = data.terraform_remote_state.networking.outputs.private_subnet_ids_rds
  vpc_id             = data.terraform_remote_state.networking.outputs.vpc_id
  allowed_source_sgs = [data.terraform_remote_state.networking.outputs.bastion_sg_id, module.eks.eks_node_group_sg]
}

### Ingress
module "ingress" {
  source     = "../modules/ingress"
  depends_on = [module.eks]
}


### DNS
module "dns" {
  source    = "../modules/dns"
  zone_name = var.dns_zone_name
  # alb_dns_records = [data.kubernetes_service.nginx_public.status[0].load_balancer[0].ingress[0].hostname]
  alb_dns_records = [local.alb_hostname]
  public_hostname = var.dns_public_hostname
}

module "app" {
  source = "../modules/app"
  postgres_host = module.rds.db_endpoint
  domain_name = var.domain_name
  ingress_class = var.ingress_class
  postgres_secret_username = local.db_secret.username
  postgres_secret_password = local.db_secret.password
  tls_secret_name = var.tls_secret_name
  cluster_issuer = var.cluster_issuer
  depends_on = [module.eks]
}






