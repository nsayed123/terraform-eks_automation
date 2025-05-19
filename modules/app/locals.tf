# locals {
# #   postgres_secret = jsondecode(data.aws_secretsmanager_secret_version.postgres_version.secret_string)

#   values_yaml =
#     structured_values = {
#     externalDatabase = {
#       enabled  = true
#       host     = var.postgres_host
#       port     = 5432
#       database = "superset"
#       username = var.postgres_secret_username
#       password = var.postgres_secret_password
#     }

#     postgresql = {
#       enabled = false
#     }

#     ingress = {
#       enabled           = true
#       ingressClassName  = var.ingress_class
#       annotations = {
#         "cert-manager.io/cluster-issuer"             = "letsencrypt"
#         "nginx.ingress.kubernetes.io/rewrite-target" = "/"
#       }
#       hosts = [{
#         host  = var.domain_name
#         paths = [{
#           path     = "/"
#           pathType = "Prefix"
#         }]
#       }]
#       tls = [{
#         secretName = "superset-tls"
#         hosts      = [var.domain_name]
#       }]
#     }

#     supersetNode = {
#       replicas = 1
#     }
#   }
# }

locals {
  structured_values = {
    externalDatabase = {
      enabled  = true
      host     = var.postgres_host
      port     = 5432
      database = "superset"
      username = var.postgres_secret_username
      password = var.postgres_secret_password
    }

    postgresql = {
      enabled = false
    }

    ingress = {
      enabled          = true
      ingressClassName = var.ingress_class
      path             = "/" # ✅ Define path here
      annotations = {
        "cert-manager.io/cluster-issuer"             = "letsencrypt"
        "nginx.ingress.kubernetes.io/rewrite-target" = "/"
      }
      hosts = [var.domain_name] # ✅ List of strings

      tls = [{
        secretName = "superset-tls"
        hosts      = [var.domain_name]
      }]
    }


    supersetNode = {
      replicas = 1
    }
  }
}
