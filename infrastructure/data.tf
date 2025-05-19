data "terraform_remote_state" "networking" {
  backend = "s3" # or local, consul, etc.

  config = {
    bucket  = var.network_tfstate_bucket
    key     = var.network_tfstate_key
    region  = var.network_tfstate_region
    profile = var.network_tfstate_profile
  }
}




data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

data "aws_secretsmanager_secret" "db_secret" {
  name = var.db_secret_name
}

data "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = data.aws_secretsmanager_secret.db_secret.id
}

# data "aws_secretsmanager_secret" "superset_secret" {
#   name = var.superset_secret
# }

# data "aws_secretsmanager_secret_version" "superset_secret_version" {
#   secret_id = data.aws_secretsmanager_secret.superset_secret.id
# }


data "kubernetes_service" "nginx_public" {
  metadata {
    name      = "nginx-ingress-public-ingress-nginx-controller"
    namespace = "ingress-nginx-public"
  }

  depends_on = [module.ingress]
}

data "template_file" "aws_auth" {
  template = file("${path.cwd}/aws-auth.yaml.tpl")

  vars = {
    node_group_role_arn = module.eks.node_role_arn
    bastion_role_arn    = data.terraform_remote_state.networking.outputs.bastion_role_arn
  }
}
