locals {
  static_values_file = yamldecode(file("${path.module}/helm-values.yaml"))

  config_overrides = {
    configOverrides = {
      secret = <<EOF
      SECRET_KEY = "${random_bytes.secret_bytes.b64_std}"
      EOF
    }
  }
  postgresql = {
      enabled = false
    }
  dynamic_overrides = {
    externalDatabase = {
      host     = var.postgres_host
      username = var.postgres_secret_username
      password = var.postgres_secret_password
    }

    ingress = {
      enabled          = true
      ingressClassName = var.ingress_class
      path             = "/"
      annotations = {
        "cert-manager.io/cluster-issuer"             = var.cluster_issuer
        "nginx.ingress.kubernetes.io/rewrite-target" = "/"
      }
      hosts = [var.domain_name]

      tls = [{
        secretName = var.tls_secret_name
        hosts      = [var.domain_name]
      }]
    }
  }

  merged_values = merge(local.static_values_file, local.dynamic_overrides, local.config_overrides)
}
# locals {
#   structured_values = {
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
#       enabled          = true
#       ingressClassName = var.ingress_class
#       path             = "/" # ✅ Define path here
#       annotations = {
#         "cert-manager.io/cluster-issuer"             = "letsencrypt"
#         "nginx.ingress.kubernetes.io/rewrite-target" = "/"
#       }
#       hosts = [var.domain_name] # ✅ List of strings

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
