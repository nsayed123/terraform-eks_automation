# Superset Helm Deployment Terraform Module


# Fetch credentials from Secrets Manager
# data "aws_secretsmanager_secret" "postgres" {
#   name = var.postgres_secret_name
# }

# data "aws_secretsmanager_secret_version" "postgres_version" {
#   secret_id = data.aws_secretsmanager_secret.postgres.id
# }



resource "kubernetes_namespace" "superset" {
  metadata {
    name = var.namespace
  }
}

# resource "local_file" "values_yaml" {
#   content  = local.values_yaml
#   filename = "${path.module}/values.yaml"
# }

resource "helm_release" "superset" {
  name       = "superset"
  namespace  = var.namespace
  repository = "https://apache.github.io/superset"
  chart      = "superset"
  version    = "0.11.0" # Update as needed

  values = [
    yamlencode(local.structured_values)
  ]
  depends_on = [kubernetes_namespace.superset]
}