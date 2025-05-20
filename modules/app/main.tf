# Superset Helm Deployment Terraform Module


# Fetch credentials from Secrets Manager
# data "aws_secretsmanager_secret" "postgres" {
#   name = var.postgres_secret_name
# }

# data "aws_secretsmanager_secret_version" "postgres_version" {
#   secret_id = data.aws_secretsmanager_secret.postgres.id
# }


resource "random_password" "base64_key" {
  length           = 42
  special          = false
}


# resource "helm_release" "superset" {
#   name       = "superset"
#   # namespace  = var.namespace
#   repository = "https://apache.github.io/superset"
#   chart      = "superset"
#   version    = "0.14.2" # Update as needed

#   # values = [
#   #   yamlencode(local.structured_values)
#   # ]
#   values = [
#     yamlencode(local.merged_values)
#   ]
#   depends_on = [random_password.base64_key, kubernetes_job.create_superset_db]
# }