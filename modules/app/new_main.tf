resource "helm_release" "superset" {
  name       = "superset"
  repository = "https://apache.github.io/superset"
  chart      = "superset"
  version    = "0.14.2"

  values = [
    yamlencode({
      secretKey = local.secret_key_value

      configOverrides = {
        secret = <<-EOT
          SECRET_KEY = "${local.secret_key_value}"
        EOT
      }

    #   init = {
    #     enabled = true
    #   }

      postgresql = {
        enabled = false
      }

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
    supersetNode = {
        replicas = {
          enabled      = true
          replicaCount = 1
        }
        command = [
          "/bin/sh",
          "-c",
          "pip3 install psycopg2-binary pyhive && superset run -p 8088 --with-threads --reload --debugger"
        ]
        resources = {}
        connections = {
            db_host     = var.postgres_host
            db_user = var.postgres_secret_username
            db_pass = var.postgres_secret_password
        }
      }
      supersetWorker = {
        replicas = {
          enabled      = true
          replicaCount = 1
        }
        command = [
          "/bin/sh",
          "-c",
          "pip3 install psycopg2-binary pyhive && celery --app=superset.tasks.celery_app:app worker"
        ]
        
      }
    })
  ]
  depends_on = [random_password.base64_key, kubernetes_job.create_superset_db]
}