locals {
  db_secret = jsondecode(data.aws_secretsmanager_secret_version.db_secret_version.secret_string)
  #   superset_secret = jsondecode(data.aws_secretsmanager_secret_version.superset_secret_version.secret_string)
  alb_hostname = try(
    data.kubernetes_service.nginx_public.status[0].load_balancer[0].ingress[0].hostname,
    ""
  )

  create_dns = length(local.alb_hostname) > 0
}